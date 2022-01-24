import std.stdio;
import std.string;

char get(string[] data, int i, int j) {
  if (i < 0 || j < 0 || i >= data.length || j >= data[i].length)
    return 'A';
  return data[i][j];
}

void main() {
  File input = File("input.txt", "r");
  string[] data;
  string line = input.readln.chomp;
  int n = line.length;
  while (!line.empty()) {
    data ~= line;
    line = input.readln.chomp;
  }
  int ans = 0;
  for (int i = 0; i < data.length; ++i)
    for (int j = 0; j < n; ++j)
      if (data[i][j] < data.get(i, j + 1) && data[i][j] < data.get(i, j - 1)
          && data[i][j] < data.get(i + 1, j) && data[i][j] < data.get(i - 1, j))
        ans += data[i][j] - '0' + 1;
  ans.writeln;
}
