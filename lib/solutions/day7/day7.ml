(*Function which takes input of an array of characters, indices,
  and checks whats on those indices.*)
(*It returns back the modified array, and next indices to check*)
let safe_set arr idx a =
  if idx < Array.length arr || idx > 0 then 
    Array.set arr idx a

let evaluate_line line_s idxes =
  let line = String.to_seq line_s |> Array.of_seq in
  let rec loop idxes line next_idxes acc =
    match idxes with
    | [] ->
        ( Array.fold_left (fun acc x -> acc ^ String.make 1 x) "" line,
          List.rev next_idxes,
          acc )
    | idx :: rest -> (
        match line.(idx) with
        | '^' ->
            (*split the beam here*)
            safe_set line (idx - 1) '|';
            safe_set line (idx + 1) '|';
            loop rest line ((idx - 1) :: (idx + 1) :: next_idxes) (acc + 1)
        | '|' ->
            (*tachyon already present, just skip since it merged*)
            loop rest line (next_idxes) acc
        | '.' ->
            (*propagate tachyon*)
            safe_set line idx '|';
            loop rest line (idx :: next_idxes) acc
        | 'S' ->
            (*start pos*)
            loop rest line (idx :: next_idxes) acc
        | _ -> failwith (Printf.sprintf "Unhandled line symbol %c\n" line.(idx))
        )
  in
  loop idxes line [] 0

let evaluate_diagram lines =
  let rec loop lines idxes acc =
    match lines with
    | [] -> acc
    | line :: rest ->
        let new_line, new_idxes, new_acc = evaluate_line line idxes in
        Printf.printf "%s\n" new_line;
        loop rest new_idxes (acc + new_acc)
  in
  loop lines [ String.length (List.hd lines) / 2 ] 0

(*Part 2: Instead of maintaining diagram, maintain how many beams are at a line 
  and how they propagating*)
let evaluate_line_2 line_s current_counts =
  let width = Array.length current_counts in
  let next_counts = Array.make width 0 in
  
  for i = 0 to width - 1 do
    let active_beams = current_counts.(i) in
    if active_beams > 0 then (
      match line_s.[i] with
      | '^' ->
          if i > 0 then 
            next_counts.(i - 1) <- next_counts.(i - 1) + active_beams;
          if i < width - 1 then 
            next_counts.(i + 1) <- next_counts.(i + 1) + active_beams
      | '.' | 'S' | '|' ->
          next_counts.(i) <- next_counts.(i) + active_beams
      | c -> failwith (Printf.sprintf "Unhandled symbol %c" c)
    )
  done;
  next_counts

let evaluate_diagram_2 lines =
  let width = String.length (List.hd lines) in
  let start_counts = Array.make width 0 in
  start_counts.(width / 2) <- 1;

  let final_counts = List.fold_left (fun counts line -> 
      evaluate_line_2 line counts
  ) start_counts lines in
  
  Array.fold_left (+) 0 final_counts

let parse_raw raw =
  let lines = String.split_on_char '\n' (String.trim raw) in
  lines

let solve filename =
  let raw = Utils.read_whole_file filename in
  let lines = parse_raw raw in
  let part1 = evaluate_diagram lines in
  let part2 = evaluate_diagram_2 lines in
  Printf.printf "part1: %d\npart2: %d\n" part1 part2