(* Part 1 functions *)
let process_input raw =
  let i_l = String.split_on_char '\n' (String.trim raw) in
  let rec loop i_l num_ls op_l =
    match i_l with
    | [] -> (List.rev num_ls, List.rev op_l)
    | "" :: rest -> loop rest num_ls op_l
    | h :: rest ->
        let arr =
          List.filter
            (fun x -> x <> "")
            (String.split_on_char ' ' (String.trim h))
        in
        if Str.string_match (Str.regexp "[0-9]+") (List.hd arr) 0 then
          loop rest (List.map int_of_string arr :: num_ls) op_l
        else if Str.string_match (Str.regexp "[\\+,\\*]") (List.hd arr) 0 then
          loop rest num_ls (arr :: op_l)
        else failwith "Invalid input!"
  in
  loop i_l [] []

let calc_int nums op =
  match op with
  | "*" -> List.fold_left ( * ) 1 nums
  | "+" -> List.fold_left ( + ) 0 nums
  | _ -> failwith "Invalid Op?"

let rec get_heads_int nums_l acc new_nums_l =
  match nums_l with
  | [] -> (List.rev acc, List.rev new_nums_l)
  | h :: t -> get_heads_int t (List.hd h :: acc) (List.tl h :: new_nums_l)

let rec calculate nums_l ops_l acc =
  match ops_l with
  | [] -> acc
  | op :: rest ->
      let heads, new_nums_l = get_heads_int nums_l [] [] in
      calculate new_nums_l rest (acc + calc_int heads op)

(* Part 2 functions *)
let get_num_string s =
  let arr = String.to_seq s |> List.of_seq in
  let buf = Buffer.create (List.length arr) in
  let rec loop arr =
    match arr with
    | [] -> Buffer.contents buf
    | ' ' :: rest -> loop rest
    | c :: rest ->
        Buffer.add_char buf c;
        loop rest
  in
  loop arr

let mult_fold acc num_string =
  if num_string = "" then acc else acc * int_of_string num_string

let mult_add acc num_string =
  if num_string = "" then acc else acc + int_of_string num_string

let calc str_nums_l ops =
  match ops with
  | '*' -> List.fold_left mult_fold 1 str_nums_l
  | '+' -> List.fold_left mult_add 0 str_nums_l
  | _ -> failwith "Invalid Op!!"

let get_heads numsls =
  let buf = Buffer.create (List.length numsls) in
  let rec loop numsls new_numsls =
    match numsls with
    | [] ->
        let res = Buffer.contents buf in
        (res, List.rev new_numsls)
    | nums :: rest -> (
        match Seq.uncons nums with
        | Some (h, t) ->
            Buffer.add_char buf h;
            loop rest (t :: new_numsls)
        | None ->
            loop rest (nums :: new_numsls))
  in
  loop numsls []

let get_col_nums nums_seq_l =
  let filler = String.make (List.length nums_seq_l) ' ' in
  let rec loop nums_seq_l acc taken =
    let num_str, rest = get_heads nums_seq_l in
    if num_str = filler then (List.rev acc, rest, taken)
    else if num_str = "" then (List.rev acc, rest, taken)
    else loop rest (String.trim num_str :: acc) (taken + 1)
  in
  loop nums_seq_l [] 0

let calculator2 num_seq_l ops_s =
  let rec loop num_seq_l ops_s acc =
    match Seq.uncons ops_s with
    | Some (op, rest_ops_s) ->
        let nums, rest_num_seq_l, taken = get_col_nums num_seq_l in
        (* Printf.printf "Op: %c, Nums: [%s], Taken: %d\n" op *)
          (* (String.concat "; " nums) taken; *)
        let new_acc = calc nums op in
        (* Printf.printf "Calculated: %d, New Acc: %d\n" new_acc (acc + new_acc); *)
        loop rest_num_seq_l (Seq.drop taken rest_ops_s) (acc + new_acc)
    | None -> acc
  in
  loop num_seq_l ops_s 0

let parselines lines =
  let op_line_regexp = Str.regexp "^[\\+\\* ]+$" in
  let rec loop lines numsl opsl =
    match lines with
    | [] -> (List.rev numsl, opsl)
    | "" :: _ -> (List.rev numsl, opsl) (*TODO: we simply drop an empty line, and don't process further, maybe look at this more carefully next time*)
    | line :: rest ->
        if Str.string_match op_line_regexp line 0 then
          loop rest numsl (String.to_seq line)
        else loop rest (String.to_seq line :: numsl) opsl
  in
  loop lines [] (String.to_seq "")

let solve filename =
  let raw = Utils.read_whole_file filename in
  let lines = String.split_on_char '\n' raw in
  
  (* Part 1 *)
  let nums_l, op_l = process_input raw in
  let part1 = calculate nums_l (List.hd op_l) 0 in
  
  (* Part 2 *)
  let (nums_seq_l, ops_s) = parselines lines in
  let part2 = calculator2 nums_seq_l ops_s in
  
  Printf.printf "part1: %d\npart2: %d\n" part1 part2