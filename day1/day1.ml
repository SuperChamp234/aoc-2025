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

let pos_mod a b = ((a mod b) + b) mod b

let operate_on_dial dial opt num =
  match opt with
  | 'L' -> pos_mod (dial - num + 100) 100
  | 'R' -> pos_mod (dial + num) 100
  | _ -> failwith "unexpected operation on dial"

let day1_part_1 lines initial_dial =
  let rec process acc d = function
    | [] -> acc
    | (opt, num) :: t ->
        let new_d = operate_on_dial d opt num in
        if new_d = 0 then process (acc + 1) new_d t else process acc new_d t
  in
  process 0 initial_dial lines

let operate_on_dial_2 dial opt num =
  let rec operate acc d remaining =
    if remaining = 0 then (d, acc)
    else
      match opt with
      | 'L' ->
          let d' = if d = 0 then 99 else d - 1 in
          let acc' = if d' = 0 then acc + 1 else acc in
          operate acc' d' (remaining - 1)
      | 'R' ->
          let d' = if d = 99 then 0 else d + 1 in
          let acc' = if d' = 0 then acc + 1 else acc in
          operate acc' d' (remaining - 1)
      | _ -> failwith "unexpected operation on dial"
  in
  operate 0 dial num

let parse_line s =
  let s = String.trim s in
  if s = "" then None
  else
    let opt = s.[0] in
    let n =
      try int_of_string (String.sub s 1 (String.length s - 1))
      with _ -> failwith ("bad integer in line: " ^ s)
    in
    Some (opt, n)

let day1_part_2 lines initial_dial =
  let rec process acc d = function
    | [] -> acc
    | (opt, num) :: t ->
        let new_d, wraps = operate_on_dial_2 d opt num in
        process (acc + wraps) new_d t
  in
  process 0 initial_dial lines

let () =
  if Array.length Sys.argv < 2 then
    Printf.printf "Usage: %s <filename>\n" Sys.argv.(0)
  else
    let filename = Sys.argv.(1) in
    let raw = read_whole_file filename in
    let ops = String.split_on_char '\n' raw |> List.filter_map parse_line in
    let initial = 50 in
    let p1 = day1_part_1 ops initial in
    let p2 = day1_part_2 ops initial in
    printf "part1: %d\npart2: %d\n" p1 p2
