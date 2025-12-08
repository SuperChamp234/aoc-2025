let () =
  if Array.length Sys.argv < 3 then begin
    Printf.eprintf "Usage: %s <day> <input_file>\n" Sys.argv.(0);
    Printf.eprintf "Example: dune exec aoc_2025 day1 input.txt\n";
    exit 1
  end;
  
  let day = Sys.argv.(1) in
  let input_file = Sys.argv.(2) in
  
  match day with
  | "day1" -> Day1.solve input_file
  | "day2" -> Day2.solve input_file
  | "day3" -> Day3.solve input_file
  | "day4" -> Day4.solve input_file
  | "day5" -> Day5.solve input_file
  | _ -> 
      Printf.eprintf "Unknown day: %s\n" day;
      Printf.eprintf "Available days: day1, day2, day3, day4, day5\n";
      exit 1
