import std.stdio;
import std.string;
import std.algorithm;

void main() {
  File input = File("input.txt", "r");
  string line = input.readln.chomp;
  int ans = 0;
  while (!line.empty()) {
    int delimiter = line.indexOf("|");
    string[] out_nums = line[delimiter + 2 .. $].split;

    foreach (num; out_nums)
      if (num.length.among(2, 3, 4, 7))
        ++ans;

    line = input.readln.chomp;
  }
  ans.writeln;
}
