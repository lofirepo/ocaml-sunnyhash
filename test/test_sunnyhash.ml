module SH = Sunnyhash
open OUnit2
open Printf

module ResultSet = Set.Make(struct type t = int let compare = (-) end)

let input = [
    "a";
    "b";
    "c";
    "aa";
    "ab";
    "ac";
    "aaa";
    "abc";
    "abd";
    "abe";
    "abcd";
    "abcde";
    "abcdef";
    "abcdefg";
    "abcdefgh";
    "abcdefghi";
    "abcdefghij";
    "abcdefghijk";
  ]

let hash sh x =
  let h = SH.hash sh x in
  printf "H(%11s) = %11u\n" x h;
  h

let test_hash_rnd _ctx =
  printf "\nHashing with random key\n";
  let sh = SH.init 32 in
  let result = List.map (hash sh) input in
  let _ =
    List.fold_left
      (fun a x ->
        assert_equal (ResultSet.mem x a) false;
        ResultSet.add x a)
      ResultSet.empty
      result in
  ()

let test_hash_key _ctx =
  printf "\nHashing with static key\n";
  let key = [|
      111111111L;
      222222222L;
      333333333L;
      444444444L;
    |] in
  let sh = SH.init 11 ~key in
  let input = List.cons "aaa" input in
  let expected = [
      96029397;
      95699199;
      96567254;
      97435310;
      96028111;
      96031502;
      96034893;
      96029397;
      96032814;
      96032828;
      96032841;
      96032821;
      515714123;
      517097587;
      517103045;
      517103067;
      2186064363;
      2192645834;
      2192671786;
    ] in
  let result =
    List.map (hash sh) input in
  assert_equal result expected

let suite =
  "suite">:::
    [
      "hash_rnd">:: test_hash_rnd;
      "hash_key">:: test_hash_key;
    ]

let () =
  Random.self_init ();
  run_test_tt_main suite
