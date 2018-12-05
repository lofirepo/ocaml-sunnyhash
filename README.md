[![Build Status](https://travis-ci.org/p2pcollab/ocaml-sunnyhash.svg?branch=master)](https://travis-ci.org/p2pcollab/ocaml-sunnyhash)

# SunnyHash: Strongly Universal Hashing

SunnyHash is an OCaml implementation of strongly universal (2-independent) hashing.  It uses the Multilinear-HM algorithm described in the paper [Strongly universal hashing is fast](https://arxiv.org/abs/1202.4961)

SunnyHash is distributed under the MPL-2.0 license.

## Installation

``sunnyhash`` can be installed via `opam`:

    opam install sunnyhash

## Building

To build from source, generate documentation, and run tests, use `dune`:

    dune build
    dune build @doc
    dune runtest -f -j1 --no-buffer

In addition, the following `Makefile` targets are available
 as a shorthand for the above:

    make all
    make build
    make doc
    make test

## Documentation

The documentation and API reference is generated from the source interfaces.
It can be consulted [online][doc] or via `odig`:

    odig doc sunnyhash

[doc]: https://p2pcollab.github.io/doc/ocaml-sunnyhash/
