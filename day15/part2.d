import std.stdio;
import std.string;
import std.algorithm;
import std.array;
import std.typecons;
import std.container;
import std.conv;

int get(int[][] grid, int i, int j) {
  const int N = grid.length;
  const int M = grid[0].length;
  int res = grid[i % N][j % M];
  res += i / N + j / M;
  if (res > 9)
    res -= 9;
  return res;
}

void main() {
  File input = File("input.txt", "r");
  string line = input.readln.chomp;
  int[][] grid;
  while (!line.empty()) {
    grid ~= line.map!(x => to!int(x - '0')).array;
    line = input.readln.chomp;
  }
  int N = grid.length * 5;
  int M = grid[0].length * 5;

  int[][] dist = new int[][](N, M);
  auto q = redBlackTree!(Tuple!(int, int, int))();
  for (int i = 0; i < N; ++i)
    for (int j = 0; j < M; ++j) {
      dist[i][j] = int.max;
      if (i == 0 && j == 0)
        dist[i][j] = 0;
      q.insert(tuple(dist[i][j], i, j));
    }
  while (!q.empty) {
    auto u = q.front;
    q.removeFront;

    if (u[1] == N - 1 && u[2] == M - 1) {
      u[0].writeln;
      break;
    }

    for (int i = -1; i <= 1; ++i)
      for (int j = -1; j <= 1; ++j) {
        if (i == 0 && j == 0 || i != 0 && j != 0 || u[1] == 0 && i == -1
            || u[2] == 0 && j == -1 || u[1] == N - 1 && i == 1 || u[2] == M - 1 && j == 1)
          continue;
        auto v = tuple(dist[u[1] + i][u[2] + j], u[1] + i, u[2] + j);
        if (v !in q)
          continue;
        auto alt = u[0] + grid.get(v[1], v[2]);
        if (alt < v[0]) {
          q.removeKey(v);
          dist[v[1]][v[2]] = alt;
          q.insert(tuple(alt, v[1], v[2]));
        }
      }
  }
}
