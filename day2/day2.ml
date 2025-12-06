open Printf

let read_whole_chan chan =
  let buf = Buffer.create 4096 in
  let rec loop () =
    let line = input_line chan in
    Buffer.add_string buf line;
    Buffer.add_char buf '\n';
    loop ()
  in
  try loop () with End_of_file -> Buffer.contents buf

let read_whole_file filename =
  let chan = open_in filename in
  try
    let s = read_whole_chan chan in
    close_in chan;
    s
  with e ->
    close_in_noerr chan;
    raise e

(* Need to parse a single line in the input
  by simply first stripping with comma and then
  stripping via - to form a pair*)
let parse_line s =
  let s = String.trim s in
  if s = "" then None
  else
    let ranges = String.split_on_char ',' s in
    Some
      (List.map
         (fun x ->
           match String.split_on_char '-' x with
           | [ a; b ] -> (int_of_string a, int_of_string b)
           | _ -> failwith "Invalid range format")
         ranges)

let break_num n =
  let len = float_of_int (String.length (string_of_int n)) in
  let left = int_of_float (float_of_int n /. (10.0 ** (len /. 2.))) in
  let right = n mod int_of_float (10.0 ** (len /. 2.)) in
  (left, right)

(* core component - parse range for invalid IDs
  Invalid IDs have repeating patterns *)
let check_repeating_digits num =
  if String.length (string_of_int num) mod 2 = 0 then
    let left, right = break_num num in
    if left = right then num else 0
  else 0

let () = assert (check_repeating_digits 4545 = 4545)
let () = assert (check_repeating_digits 55 = 55)
let () = assert (check_repeating_digits 123123 = 123123)
let () = assert (check_repeating_digits 3859389 = 0)

(*For part 2, we need to generate a pattern based on a substring passed, and compare it with the original
  We keep adding extra characters to the new pattern so that we keep comparing and finding.
  We quit trying after we pass half of the array*)

let pattern_of pattern len =
  let patstr = string_of_int pattern in
  let pat_len = String.length patstr in
  if pat_len < 1 then None
  else if len mod pat_len <> 0 then None
  else
    let rec gen acc len_rem =
      if len_rem > 0 then gen (acc ^ patstr) (len_rem - pat_len) else acc
    in
    Some (gen "" len)

let () = assert (pattern_of 55 10 = Some "5555555555")
let () = assert (pattern_of 446 6 = Some "446446")
let () = assert (pattern_of 4 5 = Some "44444")

(*Now we need to create patterns for each number recursively and check until half length*)

let validate_2 num =
  let str = string_of_int num in
  let len = String.length str in
  let rec comp idx =
    if idx > len / 2 then 0
    else
      let new_acc = String.sub str 0 idx in
      let res = pattern_of (int_of_string new_acc) len in
      match res with
      | Some pattern -> if pattern = str then num else comp (idx + 1)
      | _ -> comp (idx + 1)
  in
  comp 1

let () = assert (validate_2 4545 = 4545)
let () = assert (validate_2 1111 = 1111)
let () = assert (validate_2 38593859 = 38593859)
let () = assert (validate_2 999 = 999)

(*Parse a range and give us the total of all invalid IDs*)
let parse_range func a b =
  let rec iter_range acc inum =
    if inum > b then acc else iter_range (acc + func inum) (inum + 1)
  in
  iter_range 0 a

let parse_input func arr =
  let rec iter_input acc inp =
    match inp with
    | [] -> acc
    | (a, b) :: res -> iter_input (acc + parse_range func a b) res
  in
  iter_input 0 arr

let day2_part1 inp = parse_input check_repeating_digits inp
let day2_part2 inp = parse_input validate_2 inp

let () =
  if Array.length Sys.argv < 2 then
    Printf.printf "Usage: %s <filename>\n" Sys.argv.(0)
  else
    let filename = Sys.argv.(1) in
    let raw = read_whole_file filename in
    let inp = parse_line raw in
    let p1, p2 =
      match inp with
      | Some list -> (day2_part1 list, day2_part2 list)
      | _ -> failwith "empty file!"
    in
    printf "part 1: %d\npart 2: %d\n" p1 p2
