(** SunnyHash: Strongly Universal Hashing *)

open Stdint

type t

val init :
  ?key:Int64.t array ->
  int ->
  t
(** [init ?key maxlen]

    Initialize a strongly universal hash function.

    - [maxlen]: maximum length of input data
                that can be hashed with this function
    - [key]: [maxlen/4 + 2] random bytes required for hashing;
      if not provided, it is generated using the [Nocrypto.Rng] module,
      which needs to be initialized before calling this function.
 *)

val hash :
  t ->
  string ->
  int
(** [hash t str]

    Compute 31-bit hash value of string.
 *)
