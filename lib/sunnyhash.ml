(** SunnyHash: Strongly Universal Hashing *)

open Stdint

type t = {
    maxlen: int;
    key: Uint64.t array;
  }

(** Generate random [key] array of [len] length *)
let rec gen_key ?(n=0) key len =
  if n < len
  then
    let m = Uint64.of_int64 @@ Random.int64 Int64.max_int in
    Array.set key n m;
    gen_key ~n:(n+1) key len
  else
    key

(** Initialize hash function with random values *)
let init ?key maxlen =
  let keylen = (maxlen asr 2) + 2 in
  let key =
    match key with
    | Some k ->
       if Array.length k < keylen
       then raise @@ Invalid_argument "key must be at least (maxlen / 4) + 2 long";
       Array.map Uint64.of_int64 k
    | None ->
       let k = Array.make keylen Uint64.zero in
       gen_key k keylen
  in
  { key; maxlen }

(** Get the ASCII code of the nth character from string
    or 0 if [n] is over the length of string [x] *)
let get_or_pad x n =
  if n < String.length x
  then Char.code @@ String.get x n
  else 0

(** Compute a 32-bit word value
    from 4 bytes of string [x] starting from index [n] *)
let word32 s n =
  let w = Uint32.of_int @@ get_or_pad s (n+3) in
  let w = Uint32.logor w @@
            Uint32.shift_left
              (Uint32.of_int @@ get_or_pad s (n+2))
              8 in

  let w = Uint32.logor w @@
            Uint32.shift_left
              (Uint32.of_int @@ get_or_pad s (n+1))
              16 in
  let w = Uint32.logor w @@
            Uint32.shift_left
              (Uint32.of_int @@ get_or_pad s n)
              24 in
  w

(** Multilinear-HM algorithm *)
let rec ml31r ?(n=(-1)) t x len sum =
  let a =
    if n = -1 (* prepend length *)
    then Uint64.of_int len
    else Uint64.of_uint32 @@ word32 x (4 * n) in
  let b =
    Uint64.of_uint32 @@ word32 x (4 * (n+1)) in
  let ak = Uint64.add a t.key.(n+1) in
  let bk = Uint64.add b t.key.(n+2) in
  let sum = Uint64.add sum @@ Uint64.mul ak bk in
  let n = n + 2 in
  if 4 * n < len
  then ml31r t x len sum ~n
  else Uint64.shift_right sum 31

(** Multilinear hashing producing a 31-bit hash value **)
let ml31 t s =
  let len = String.length s in
  if t.maxlen < len
  then raise @@ Invalid_argument "string is longer than maxlen";
  ml31r t s len t.key.(Array.length t.key - 1)

(** Compute 31-bit hash value of string [x] *)
let hash t x =
  Uint64.to_int @@ ml31 t x
