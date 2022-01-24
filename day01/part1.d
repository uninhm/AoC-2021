import std.stdio;
import std.conv;
import std.string;

void main() {
  File input = File("input.txt", "r");
  int count = 0;
  int last = input.readln.chomp.to!int;
  string line = input.readln.chomp;
  while (!line.empty()) {
    int current = line.to!int;
    if (current > last)
      count++;
    last = current;
    line = input.readln.chomp;
  }
  count.writeln;
}
