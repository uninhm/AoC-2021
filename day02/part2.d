import std.stdio;
import std.string;
import std.conv;

void main() {
  File input = File("input.txt", "r");
  string line = input.readln.chomp;
  int distance = 0;
  int depth = 0;
  int aim = 0;
  while (!line.empty()) {
    int space_idx = line.indexOf(' ');
    string keyword = line[0 .. space_idx];
    int arg = line[space_idx + 1 .. $].to!int;

    if (keyword == "forward") {
      distance += arg;
      depth += aim * arg;
    } else if (keyword == "up")
      aim -= arg;
    else if (keyword == "down")
      aim += arg;

    line = input.readln.chomp;
  }
  writeln(distance * depth);
}
