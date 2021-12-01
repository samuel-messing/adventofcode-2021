#!/usr/bin/env hhvm
use namespace HH\Lib\{File, IO, Str, Vec};
use namespace HH\Asio;

<<__EntryPoint>>
function main(): void {
  $input = File\open_read_only("part1.input.txt");
  $lines = Str\split(Asio\join($input->readAllAsync()), "\n");
  $last_depth = Str\to_int($lines[0]);
  $increased_measurements = 0;
  foreach (Vec\drop($lines, 1) as $line) {
    $depth = Str\to_int($line);
    if ($depth == null) {
      // To deal with the last line which is just the empty string.
      break;
    }
    $change = $last_depth < $depth ? "increased" : ($last_depth > $depth ? "decreased" : "no change");
    if ($change == "increased") $increased_measurements++;
    print("$line ($change)\n");
    $last_depth = $depth;
  }
  print("Total increased measurements: $increased_measurements\n");
}
