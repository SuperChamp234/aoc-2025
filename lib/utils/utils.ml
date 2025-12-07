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
