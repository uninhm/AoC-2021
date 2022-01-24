import std.stdio;
import std.string;
import std.format;

bool[1500][1500] grid;

void print_grid() {
  for (int y = 0; y < 10; ++y) {
    for (int x = 0; x < 100; ++x)
      if (grid[y][x])
        write('#');
      else
        write('.');
    writeln();
  }
}

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
  while (!line.empty()) {
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
    line = input.readln.chomp;
  }
  print_grid();
}
