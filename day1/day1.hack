#!/usr/bin/env hhvm
use namespace HH\Lib\{File, IO, Str, Vec};
use namespace HH\Asio;

<<__EntryPoint>>
function main(): void {
  $input = File\open_read_only("part1.input.txt");
  $lines = Str\split(Asio\join($input->readAllAsync()), "\n");

  # Part 1 --- individual measurements
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
  print("Total increased (individual) measurements: $increased_measurements\n");

  # Part 2 --- sliding window measurements
  $combined_depths = vec[];
  $first_depth = Str\to_int($lines[0]);
  $second_depth = Str\to_int($lines[1]);
  foreach (Vec\drop($lines, 2) as $line) {
    $third_depth = Str\to_int($line);
    if ($third_depth == null) {
      // To deal with the last line which is just the empty string
      break;
    }
    $combined_depths[] = $first_depth + $second_depth + $third_depth;
    $first_depth = $second_depth;
    $second_depth = $third_depth;
  }

  $last_depth = $combined_depths[0];
  $increased_measurements = 0;
  foreach (Vec\drop($combined_depths, 1) as $depth) {
    $change = $last_depth < $depth ? "increased" : ($last_depth > $depth ? "decreased" : "no change");
    if ($change == "increased") $increased_measurements++;
    $last_depth = $depth;
  }
  print("Total increased (sliding window) measurements: $increased_measurements\n");
}
