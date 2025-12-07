let merge_ranges ranges =
  let sorted = List.sort (fun (a, _) (b, _) -> compare a b) ranges in
  let rec aux acc = function
    | [] -> List.rev acc
    | (s, e) :: rest -> (
        match acc with
        | [] -> aux [ (s, e) ] rest
        | (ps, pe) :: t ->
            if s <= pe + 1 then aux ((ps, max pe e) :: t) rest
            else aux ((s, e) :: acc) rest)
  in
  aux [] sorted

let in_intervals arr x =
  let n = Array.length arr in
  let rec bs l r =
    if l > r then false
    else
      let mid = (l + r) / 2 in
      let s, e = arr.(mid) in
      if x < s then bs l (mid - 1) else if x > e then bs (mid + 1) r else true
  in
  bs 0 (n - 1)

let count_items_in_ranges ranges items =
  let merged = merge_ranges ranges in
  let arr = Array.of_list merged in
  List.fold_left
    (fun acc x -> if in_intervals arr x then acc + 1 else acc)
    0 items

let parse_input raw =
  let lines = String.split_on_char '\n' (String.trim raw) in
  let rec loop lines ranges items =
    match lines with
    | [] -> (ranges, items)
    | "" :: rest -> loop rest ranges items
    | s :: rest ->
        if String.contains s '-' then
          let res =
            List.map
              (fun x -> int_of_string (String.trim x))
              (String.split_on_char '-' s)
          in
          match res with
          | [ a; b ] -> loop rest ((a, b) :: ranges) items
          | _ -> failwith "Invalid Range!!"
        else loop rest ranges (items @ [ int_of_string s ])
  in
  loop lines [] []

let solve filename =
  let raw = Utils.read_whole_file filename in
  let ranges, items = parse_input raw in
  let part1 = count_items_in_ranges ranges items in
  let part2 = List.fold_left (fun acc (a, b) -> (acc + (b - a) + 1)) 0 (merge_ranges ranges) in
  Printf.printf "part1: %d\npart2: %d\n" part1 part2
