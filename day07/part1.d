import std.stdio;
import std.string;
import std.algorithm;
import std.array;
import std.conv;
import std.math;

void main() {
  File input = File("input.txt", "r");
  int[] pos = input.readln.chomp.split(",").map!(to!int).array;

  pos.sort;
  int selected = pos[pos.length / 2];

  int ans = 0;
  foreach (elem; pos)
    ans += abs(selected - elem);
  ans.writeln;
}
