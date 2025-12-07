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

Each day's solution is located in `lib/solutions/dayN/dayN.ml`. 

**Option 1: Compile and run directly (for solutions without dependencies)**
```bash
# Day 1 can be run directly as it doesn't use external modules
ocaml lib/solutions/day1/day1.ml <input_file>
```

**Option 2: Compile individual solutions (recommended)**
```bash
# Compile a specific day's solution
ocamlopt -o day1 lib/solutions/day1/day1.ml
./day1 <input_file>

# For days that use the Utils module (day2-day5), compile with the utils module
ocamlopt -I lib/utils -o day2 lib/utils/utils.ml lib/solutions/day2/day2.ml
./day2 <input_file>
```

Replace `<input_file>` with the path to your input file for that day's challenge.

Example:
```bash
ocamlopt -o day1 lib/solutions/day1/day1.ml
./day1 input.txt
```

### Running Tests

To run the test suite:

```bash
dune runtest
```