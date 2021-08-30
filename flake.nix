{
  description = "URPS: Uniform Random Peer Sampler";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux" "aarch64-linux" "armv7l-linux"
        "x86_64-darwin" "aarch64-darwin"
      ];
      supportedOcamlPackages = [
        "ocamlPackages_4_10"
        "ocamlPackages_4_11"
        "ocamlPackages_4_12"
      ];
      defaultOcamlPackages = "ocamlPackages_4_12";

      forAllOcamlPackages = nixpkgs.lib.genAttrs supportedOcamlPackages;
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor =
        forAllSystems (system:
          import nixpkgs {
            inherit system;
            overlays = [ self.overlay ];
          });
    in
      {
        overlay = final: prev:
          with final;
          let mkOcamlPackages = prevOcamlPackages:
                with prevOcamlPackages;
                let ocamlPackages = {
                      inherit ocaml;
                      inherit findlib;
                      inherit ocamlbuild;
                      inherit opam-file-format;
                      inherit buildDunePackage;

                      sunnyhash =
                        buildDunePackage rec {
                          pname = "sunnyhash";
                          version = "unstable-2019-09-17";
                          src = self;

                          useDune2 = true;
                          doCheck = true;

                          nativeBuildInputs = [
                            odoc
                          ];
                          buildInputs = [
                            nocrypto
                            stdint
                          ];
                          checkInputs = [
                            ounit
                          ];
                        };
                    };
                in ocamlPackages;
          in
            let allOcamlPackages =
                  forAllOcamlPackages (ocamlPackages:
                    mkOcamlPackages ocaml-ng.${ocamlPackages});
            in
              allOcamlPackages // {
                ocamlPackages = allOcamlPackages.${defaultOcamlPackages};
              };

        packages =
          forAllSystems (system:
            forAllOcamlPackages (ocamlPackages:
              nixpkgsFor.${system}.${ocamlPackages}));

        defaultPackage =
          forAllSystems (system:
            nixpkgsFor.${system}.ocamlPackages.sunnyhash);
      };
}
