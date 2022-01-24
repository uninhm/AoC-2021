import std.stdio;
import std.string;
import std.conv;
import std.format : formattedRead;
import std.algorithm : max, min;

int[1000][1000] grid;

void main() {
  File input = File("input.txt", "r");
  string line = input.readln.chomp;
  while (!line.empty()) {
    int x1, y1, x2, y2;
    formattedRead(line, "%d,%d -> %d,%d", &x1, &y1, &x2, &y2);
    if (x1 == x2)
      for (int y = min(y1, y2); y <= max(y1, y2); ++y)
        ++grid[y][x1];
    else if (y1 == y2)
          for (int x = min(x1, x2); x <= max(x1, x2); ++x)
            ++grid[y1][x];
    line = input.readln.chomp;
  }
  int ans = 0;
  for (int i = 0; i < 1000; ++i)
    for (int j = 0; j < 1000; ++j)
      if (grid[i][j] >= 2)
        ++ans;
  ans.writeln;
}
