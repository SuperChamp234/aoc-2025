# AOC 2025 Solutions by Zain :D

This repository contains my solutions for the Advent of Code 2025 challenges. Each day's solution is organized in its own directory, with code written in OCaml.

I also want to tackle Advent of FPGA by Jane Street, that's why OCaml, so that I can easily start with HardCaml later on.

Reach out to me if you wanna try something more fun for the Advent of FPGA Challenge on aoc@zainsv.me or twitter @zain_sv_ or @zainsv.me on BSky!

## Directory Structure

```
aoc-2025/
├── lib/
│   ├── solutions/       # Solutions for each day
│   │   ├── day1/       # Day 1 solution
│   │   ├── day2/       # Day 2 solution
│   │   ├── day3/       # Day 3 solution
│   │   ├── day4/       # Day 4 solution
│   │   └── day5/       # Day 5 solution
│   └── utils/          # Utility functions
│       ├── utils.ml
│       └── utils.mli
├── test/               # Test files
├── dune-project        # Dune project configuration
└── aoc-2025.opam       # OPAM package file
```

## How to Run

### Prerequisites

- OCaml (version 4.08 or later)
- Dune build system (version 3.20 or later)
- OPAM (OCaml package manager)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/SuperChamp234/aoc-2025.git
   cd aoc-2025
   ```

2. Install dependencies:
   ```bash
   opam install . --deps-only
   ```

3. Build the project:
   ```bash
   dune build
   ```

### Running Solutions

Each day's solution is located in `lib/solutions/dayN/dayN.ml`. To run a specific day's solution:

```bash
# Run directly with OCaml interpreter
ocaml lib/solutions/day1/day1.ml <input_file>
ocaml lib/solutions/day2/day2.ml <input_file>
# ... and so on for other days
```

Replace `<input_file>` with the path to your input file for that day's challenge.

Example:
```bash
ocaml lib/solutions/day1/day1.ml input.txt
```

### Running Tests

To run the test suite:

```bash
dune runtest
```