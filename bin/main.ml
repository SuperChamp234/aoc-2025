let () =
  if Array.length Sys.argv < 3 then begin
    Printf.eprintf "Usage: %s <day> <input_file>\n" Sys.argv.(0);
    Printf.eprintf "Example: dune exec aoc_2025 day1 input.txt\n";
    exit 1
  end;
  
  let day = Sys.argv.(1) in
  let input_file = Sys.argv.(2) in
  
  match day with
  | "1" -> Day1.solve input_file
  | "2" -> Day2.solve input_file
  | "3" -> Day3.solve input_file
  | "4" -> Day4.solve input_file
  | "5" -> Day5.solve input_file
  | "6" -> Day6.solve input_file
  | _ -> 
      Printf.eprintf "Unimplemented day!\n";
      exit 1
