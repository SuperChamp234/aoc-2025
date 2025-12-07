let parse_file raw =
  let lines = String.split_on_char '\n' (String.trim raw) in
  let string_to_char_list s =
    List.init (String.length s) (fun i -> String.get s i)
  in
  List.map string_to_char_list lines

let score i j mat =
  mat.(i - 1).(j)
  + mat.(i + 1).(j)
  + mat.(i).(j - 1)
  + mat.(i).(j + 1)
  + mat.(i - 1).(j - 1)
  + mat.(i - 1).(j + 1)
  + mat.(i + 1).(j + 1)
  + mat.(i + 1).(j - 1)

let evaluate_mat inp n_r n_c rows cols =
  let n_rows = Array.length inp in
  if n_rows = 0 then 0
  else
    let n_cols = Array.length inp.(0) in

    let start_i = max 0 n_r in
    let start_j = max 0 n_c in
    let end_i = min (n_rows - 1) rows in
    let end_j = min (n_cols - 1) cols in

    let ans = ref 0 in
    let sel_elems = ref [] in

    for i = start_i to end_i do
      for j = start_j to end_j do
        if inp.(i).(j) = 1 then
          let v = score i j inp in
          if v < 4 then (
            ans := !ans + 1;
            sel_elems := !sel_elems @ [(i,j)];
          )
      done
    done;
    let rec final sel_elems =
      match sel_elems with
        | [] -> !ans
        | (i, j) :: rest -> (inp.(i).(j) <- 0); final rest
    in
      final !sel_elems
  
let solve filename =
  let raw = Utils.read_whole_file filename in
  let parsed_input = parse_file raw in
  let rows = List.length parsed_input in
  let cols = List.length (List.hd parsed_input) in
  let n = rows + 2 in
  let m = cols + 2 in
  let trans_coords arr x y =
    if x = 0 || x = n - 1 || y = 0 || y = m - 1 then 0
    else
      match List.nth (List.nth arr (x - 1)) (y - 1) with
      | '@' -> 1
      | '.' -> 0
      | _ -> failwith "Invalid Input"
  in
  let pad_mat = Array.init_matrix n m (parsed_input |> trans_coords) in
  let ans =
    let rec loop acc =
      let res = evaluate_mat pad_mat 1 1 rows cols in
      match res with
        | 0 -> acc
        | _ -> loop (acc + res)
    in
    loop (evaluate_mat pad_mat 1 1 rows cols)
  in
  Printf.printf "part1: %d\n" ans
