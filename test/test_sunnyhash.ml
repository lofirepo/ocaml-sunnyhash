module SH = Sunnyhash
open OUnit2
open Printf

let hash sh x =
  let h = SH.hash31 sh x in
  printf "H(%s) = %lu\n" x h;
  h

let test_hash_rnd _ctx =
  printf "\nHashing with random key\n";
  let sh = SH.init 32 in
  let a1 = hash sh "abc" in
  let a2 = hash sh "abc" in
  let b1 = hash sh "def" in
  assert_equal a1 a2;
  assert_equal (a1 = b1) false

let test_hash_key _ctx =
  printf "\nHashing with static key\n";
  let key = [|
      111111L;
      222222L;
      333333L;
      444444L;
    |] in
  let sh = SH.init 11 ~key in
  let str = [
      "a";
      "aa";
      "aaa";
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
    ] in
  let hash1 = [
      11l;
      12l;
      341l;
      341l;
      348l;
      351l;
      355l;
      87157l;
      87226l;
      87233l;
      88630l;
      449742l;
      449828l;
      471967l;
      6192720l;
    ] in
  let hash2 =
    List.map (hash sh) str in
  assert_equal hash1 hash2


let suite =
  "suite">:::
    [
      "hash_rnd">:: test_hash_rnd;
      "hash_key">:: test_hash_key;
    ]

let () =
  Random.self_init ();
  run_test_tt_main suite
