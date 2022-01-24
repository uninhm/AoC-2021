import std.stdio;
import std.string;
import std.algorithm;
import std.array;
import std.conv;
import std.math;

void main() {
  File input = File("input.txt", "r");
  int[] pos = input.readln.chomp.split(",").map!(to!int).array;

  int min_ans = int.max;
  for (int selected = 0; selected < 2000; ++selected) {
    int ans = 0;
    foreach (elem; pos) {
      int d = abs(selected - elem);
      ans += d * (d + 1) / 2;
    }
    if (ans < min_ans)
      min_ans = ans;
  }
  min_ans.writeln;
}
