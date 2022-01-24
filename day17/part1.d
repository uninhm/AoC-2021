import std.stdio;
import std.string;
import std.format : formattedRead;

void main() {
  File input = File("input.txt", "r");
  string line = input.readln.chomp;
  int minx, maxx, miny, maxy;
  line.formattedRead("target area: x=%d..%d, y=%d..%d", &minx, &maxx, &miny, &maxy);

  int ansy = 0;
  int ansx = 0;
  for (int ivx = 0; ivx < 150; ++ivx)
    for (int ivy = -50; ivy < 1500; ++ivy) {
      int vx = ivx;
      int vy = ivy;
      int x = 0;
      int y = 0;
      for (int t = 0; t < 1000; ++t) {
        x += vx;
        y += vy;
        if (vx)
          vx -= 1;
        vy -= 1;
        if (minx <= x && x <= maxx && miny <= y && y <= maxy && ivy > ansy) {
          ansy = ivy;
          ansx = ivx;
        }
      }
    }
  int ansh = -1;
  int y = 0;
  int vy = ansy;
  while (y > ansh) {
    ansh = y;
    y += vy;
    vy -= 1;
  }
  "%d, %d -> %d".writefln(ansx, ansy, ansh);
}
