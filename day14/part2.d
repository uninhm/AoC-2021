import std.stdio;
import std.string;
import std.format : formattedRead;
import std.algorithm : map, maxElement, minElement;
import std.array : array;
import std.conv : to;

const int N = 40;

T1[T2] addition(T1, T2)(T1[T2] a, T1[T2] b) {
  auto c = a.dup;
  foreach (key, val; b)
    if (key in c)
      c[key] += val;
    else
      c[key] = val;
  return c;
}

void add(T1, T2)(ref T1[T2] a, T1[T2] b) {
  foreach (key, val; b)
    if (key in a)
      a[key] += val;
    else
      a[key] = val;
}

void main() {
  File input = File("input.txt", "r");
  char[] s = input.readln.chomp.map!(to!char).array;
  input.readln; // skip empty line
  string line = input.readln.chomp;
  char[char[2]] m;
  while (!line.empty()) {
    char a, b, c;
    line.formattedRead("%c%c -> %c", &a, &b, &c);
    m[[a, b]] = c;
    line = input.readln.chomp;
  }

  long[char][char[2]][N + 1] dp;
  foreach (elem; m.keys) {
    long[char] aa;
    aa[elem[1]] = 1;
    dp[0][elem] = aa;
  }
  for (int rem_steps = 1; rem_steps <= N; ++rem_steps)
    foreach (char[2] x; m.keys)
      dp[rem_steps][x] = addition(dp[rem_steps - 1][[x[0], m[x]]], dp[rem_steps - 1][[
            m[x], x[1]
          ]]);

  long[char] counter;
  counter[s[0]] = 1;
  for (int i = 0; i + 1 < s.length; ++i)
    counter.add(dp[40][[s[i], s[i + 1]]]);

  writeln(counter.values.maxElement - counter.values.minElement);
}
