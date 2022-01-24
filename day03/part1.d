import std.stdio;
import std.string;

void main() {
  File input = File("input.txt", "r");
  string line = input.readln.chomp;
  int n = line.length;
  int[][] a = new int[][](n, 2);
  while (!line.empty()) {
    for (int i = 0; i < n; ++i)
      a[i][line[i] - '0']++;
    line = input.readln.chomp;
  }
  int gamma = 0;
  for (int i = 0; i < n; ++i) {
    if (a[i][1] > a[i][0])
      gamma += 1 << (n - i - 1);
  }
  int epsilon = gamma ^ ((1 << n) - 1);

  "%s * %s = %s".writefln(gamma, epsilon, gamma * epsilon);
}
