import std.stdio;
import std.string;
import std.format;
import std.container: redBlackTree, RedBlackTree;
import std.typecons: tuple, Tuple;
import std.algorithm: max;

void print(RedBlackTree!(Tuple!(int, int)) grid) {
  int max_x = 0;
  int max_y = 0;

  foreach (x, y; grid) {
    max_x = max(max_x, x);
    max_y = max(max_y, y);
  }

  for (int y = 0; y <= max_y; y++) {
    for (int x = 0; x <= max_x; x++) {
      if (tuple(x, y) in grid) {
        "#".write;
      } else {
        ".".write;
      }
    }
    writeln;
  }
}

void main() {
    File input = File("input.txt", "r");
    string line = input.readln.chomp;
    auto grid = redBlackTree!(Tuple!(int, int))();
    while (!line.empty()) {
        int x, y;
        line.formattedRead("%s,%s", &x, &y);
        grid.insert(tuple(x, y));
        line = input.readln.chomp;
    }
    line = input.readln.chomp;
    while (!line.empty()) {
        char axis;
        int coord;
        line.formattedRead("fold along %s=%s", &axis, &coord);
        auto newgrid = redBlackTree!(Tuple!(int, int))();
        if (axis == 'y') {
          foreach (x, y; grid) {
            if (y > coord)
              newgrid.insert(tuple(x, 2*coord - y));
            else if (y < coord)
              newgrid.insert(tuple(x, y));
          }
        } else {
          foreach (x, y; grid) {
            if (x > coord)
              newgrid.insert(tuple(2*coord - x, y));
            else if (x < coord)
              newgrid.insert(tuple(x, y));
          }
        }
        line = input.readln.chomp;
        grid = newgrid;
    }
    grid.print;
}
