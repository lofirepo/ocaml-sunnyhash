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
      if not provided, it is generated using the [Random] module,
      which needs to be initialized before calling this function.
 *)

val hash32 :
  t ->
  string ->
  Uint32.t
(** [hash31 t str]

    Compute 32-bit hash value of string.
 *)

val hash31 :
  t ->
  string ->
  Int32.t
(** [hash31 t str]

    Compute 31-bit hash value of string.
 *)
