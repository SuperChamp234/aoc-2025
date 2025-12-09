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
  let (nums_seq_l, ops_s) = parselines lines in
  let part2 = calculator2 nums_seq_l ops_s in
  Printf.printf "part2: %d\n" part2