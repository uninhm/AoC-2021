import std.stdio;
import std.string;
import std.format;

bool[1500][1500] grid;

void main() {
  File input = File("input.txt", "r");
  string line = input.readln.chomp;
  while (!line.empty()) {
    int x, y;
    line.formattedRead("%s,%s", &x, &y);
    grid[y][x] = true;
    line = input.readln.chomp;
  }
  line = input.readln.chomp;
  char axis;
  int coord;
  line.formattedRead("fold along %s=%s", &axis, &coord);
  if (axis == 'y') {
    for (int x = 0; x < grid[coord].length; ++x)
      grid[coord][x] = false;
    for (int y = 1; y <= coord; ++y)
      for (int x = 0; x < grid[y].length; ++x) {
        grid[coord - y][x] |= grid[coord + y][x];
        grid[coord + y][x] = false;
      }
  } else { // axis == 'x'
    for (int y = 0; y < grid.length; ++y)
      grid[y][coord] = false;
    for (int x = 1; x <= coord; ++x)
      for (int y = 0; y < grid.length; ++y) {
        grid[y][coord - x] |= grid[y][coord + x];
        grid[y][coord + x] = false;
      }
  }

  int ans = 0;
  for (int y = 0; y < grid.length; ++y)
    for (int x = 0; x < grid[y].length; ++x)
      if (grid[y][x])
        ++ans;
  ans.writeln;
}
