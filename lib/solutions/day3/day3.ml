open Printf

let parse_line s =
  let s = String.trim s in
  if s = "" then None
  else
    let battery_strs = String.split_on_char '\n' s in
    let string_to_int_list s =
      List.init (String.length s) (fun i ->
          int_of_char (String.get s i) - int_of_char '0')
    in
    Some (List.map string_to_int_list battery_strs)

let find_n_batteries n arr =
  let len = List.length arr in
  if len = 0 || n <= 0 then 0
  else
    let n = if n > len then len else n in
    let drop = len - n in
    let stack = Stack.create () in

    let rec loop rem = function
      | [] -> rem
      | x :: xs ->
          let rec pop_while r =
            if r > 0 && (not (Stack.is_empty stack)) && Stack.top stack < x then (
              ignore (Stack.pop stack);
              pop_while (r - 1))
            else r
          in
          let rem' = pop_while rem in
          Stack.push x stack;
          loop rem' xs
    in

    let rem_after = loop drop arr in

    let rec drop_left d =
      if d <= 0 || Stack.is_empty stack then ()
      else (
        ignore (Stack.pop stack);
        drop_left (d - 1))
    in
    drop_left rem_after;
    let rec to_list acc =
      if Stack.is_empty stack then acc else to_list (Stack.pop stack :: acc)
    in
    let digits = to_list [] in

    let rec take k l =
      if k <= 0 then []
      else match l with [] -> [] | h :: t -> h :: take (k - 1) t
    in
    let digits = take n digits in

    List.fold_left (fun acc d -> (acc * 10) + d) 0 digits

let rec sum lst = match lst with [] -> 0 | h :: t -> h + sum t

let solve filename =
  let raw = Utils.read_whole_file filename in
  let inp = parse_line raw in
  match inp with
  | Some battery_arr_list ->
      let part1 = List.map (find_n_batteries 2) battery_arr_list in
      let part2 = List.map (find_n_batteries 12) battery_arr_list in
      printf "part1: %d\npart2: %d\n" (sum part1) (sum part2)
  | None -> failwith "Something wrong with input!"

let () = if Array.length Sys.argv = 2 then solve Sys.argv.(1)
