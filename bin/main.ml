(* 01 - tail of a list *)
let rec last = function
    | []      -> None
    | [x]     -> Some x
    | _ :: xs -> last xs


(* 02 - last two elements of a list *)
let rec last_two = function
    | [] | [_]     -> None
    | [x; y]       -> Some (x, y)
    | _ :: x :: xs -> last_two (x :: xs)


(* 03 - n'th element of a list *)
let rec nth l n =
    match (l, n) with
    | x :: _, 0  -> x
    | [], _      -> raise (Failure "nth")
    | _ :: xs, n -> nth xs (n - 1)


(* 04 - length of a list *)
let rec length = function
    | []      -> 0
    | _ :: xs -> 1 + length xs


(* 05 - reverse a list *)
let rec rev : 'a list -> 'a list = function
    | [] -> []
    | x :: xs -> rev xs @ [x]


(* 06 - palindrome *)
let is_palindrome x = x = rev x


(* 07 - flatten a list *)
type 'a node =
    | One of 'a
    | Many of 'a node list

let rec flatten nodes  =
    let rec flatten_elem  = function
        | (One x) -> [x]
        | (Many nodes) -> flatten nodes
    in List.concat (List.map flatten_elem nodes)


(* 08 - eliminate duplicates *)
let rec compress = function
    | [] -> []
    | [x] -> [x]
    | x :: y :: xs when x = y -> compress (y :: xs)
    | x :: y :: xs -> x :: compress (y :: xs)


(* 09 - eliminate duplicates *)
let rec pack = function
    | [] -> []
    | x :: xs ->
        let s = List.to_seq xs in
        let group = List.of_seq (Seq.take_while ((=) x) s) in
        let rest = List.of_seq (Seq.drop_while ((=) x) s) in
            (x :: group) :: pack rest
(* or using Seq.group *)
(* let pack xs = List.map (List.of_seq) (List.of_seq (Seq.group (=) (List.to_seq xs))) *)


(* 10 - run-length encoding *)
let rec encode = function
    | [] -> []
    | [x] -> [(1, x)]
    | x :: xs ->
        match encode xs with
        | (n, y) :: xs when y = x -> (n + 1, x) :: xs
        | xs -> (1, x) :: xs


(* 11 - modified run-length encoding *)
type 'a rle =
    | One of 'a
    | Many of int * 'a

let rec encode = function
    | [] -> []
    | [x] -> [One x]
    | x :: xs ->
        match encode xs with
        | One y :: xs when y = x -> Many (2, x) :: xs
        | Many (n, y) :: xs when y = x -> Many (n + 1, x) :: xs
        | xs -> One x :: xs


(* 12 - decode a run-length encoded list *)
let rec decode = function
    | [] -> []
    | One x :: xs -> x :: decode xs
    | Many (n, x) :: xs -> List.of_seq (Seq.take n (Seq.repeat x)) @ decode xs


(* 13 - run-length encoding of a list (direct solution) *)
(* didn't use pack in the last encoding problem *)


(* 14 - duplicate the elements of a list *)
let rec duplicate = function
    | [] -> []
    | x :: xs -> x :: x :: duplicate xs


(* 15 - replicate the elements of a list given number of times *)
let replicate l n =
    let rec inner = function
        | [] -> []
        | x :: xs -> List.of_seq (Seq.take n (Seq.repeat x)) @ inner xs
    in inner l


(* 16 - drop every n'th element from a list *)
let drop l n =
    let rec inner l' k =
        match (l', k) with
        | ([], _) -> []
        | (_ :: xs, 1) -> inner xs n
        | (x :: xs, k) -> x :: inner xs (k - 1)
    in inner l n


(* 17 - split a list into two parts; the length of the first part is given *)
let rec split l n =
    match (l, n) with
    | (xs, 0) -> ([], xs)
    | ([], _) -> ([], [])
    | (x :: xs, n) ->
        let (top, bot) = split xs (n - 1)
        in (x :: top, bot)


(* 18 - extract a slice from a list *)
let rec slice l lo hi =
    match (l, lo, hi) with
    | (_ :: xs, lo, hi) when lo > 0 -> slice xs (lo - 1) hi
    | (x :: xs, _, hi) when hi > 1 -> x :: slice xs 0 (hi - 1)
    | _ -> []


(* 19 - rotate a list N places to the left *)
let rec rotate l n =
    let (l1, l2) = split l n in l2 @ l1


(* 20 - remove the k'th element from a list *)
let rec remove_at n l =
    match (n, l) with
    | (_, []) -> []
    | (0, _ :: xs) -> xs
    | (n, x :: xs) -> x :: remove_at (n - 1) xs


(* 21 - insert an element at a given position into a list *)
let rec insert_at inserted n l =
    match (n, l) with
    | (0, xs) -> inserted :: xs
    | (_, []) -> [inserted]
    | (n, x :: xs) -> x :: insert_at inserted (n - 1) xs


(* 22 - Create a list containing all integers within a given range *)
let rec range lo hi =
    if lo <= hi
    then lo :: range (lo + 1) hi
    else []


(* 23 - extract a given number of randomly selected elements from a list *)
let rec rand_select l = function
    | 0 -> []
    | n -> List.nth l (Random.int (length l)) :: rand_select l (n - 1)


(* 24 - lotto: draw n different random numbers from the set 1..m *)
let rec lotto_select n hi =
    if n <= 0
    then []
    else Random.int hi + 1 :: lotto_select (n - 1) hi


(* 25 - generate a random permutation of the elements of a list *)
let rec permutation = function
    | [] -> []
    | xs ->
        let n = Random.int (length xs) in
        let picked = List.nth xs n in
        let rest = remove_at n xs in
        picked :: permutation rest
