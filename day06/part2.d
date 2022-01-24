module day06.part2;

import std.stdio;
import std.string;
import std.algorithm;
import std.conv;
import std.array;

void main() {
  File input = File("input.txt", "r");
  int[] l = input.readln.chomp.split(",").map!(to!int).array;
  long[257] dp;
  dp[0] = 1;
  for (int i = 1; i <= 256; ++i) {
    int i1 = max(i - 7, 0);
    int i2 = max(i - 9, 0);
    dp[i] = dp[i1] + dp[i2];
  }
  long ans = 0;
  foreach (elem; l) {
    ans += dp[256 - elem];
  }
  ans.writeln;
}
