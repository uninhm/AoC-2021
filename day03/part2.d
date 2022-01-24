import std.stdio;
import std.string;
import std.container;
import std.conv;

int solve(int n, RedBlackTree!int rbt, int x) {
  int i = 0;
  while (rbt.length() > 1) {
    int ones = 0;
    foreach (int elem; rbt)
      ones += (elem >> (n - i - 1)) & 1;
    auto elems = rbt.dup();
    foreach (int elem; elems) {
      int bit = (elem >> (n - i - 1)) & 1;
      if (ones >= (elems.length() + 1) / 2 && bit == x || ones < (elems.length() + 1) / 2 && bit != x)
        rbt.removeKey(elem);
    }
    i++;
  }
  return rbt.front;
}

void main() {
  File input = File("input.txt", "r");
  string line = input.readln.chomp;
  int n = line.length;
  auto rbt = redBlackTree!int();
  while (!line.empty()) {
    rbt.insert(line.to!int(2));
    line = input.readln.chomp;
  }
  auto rbt2 = rbt.dup();
  writeln(solve(n, rbt, 0) * solve(n, rbt2, 1));
}
