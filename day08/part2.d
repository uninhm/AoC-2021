import std.stdio;
import std.string;
import std.array;
import std.algorithm;
import std.conv;

bool contains(string a, string b) {
  int i = 0;
  int j = 0;
  while (i < a.length) {
    if (a[i] == b[j])
      ++j;
    if (j == b.length)
      return true;
    ++i;
  }
  return false;
}

bool contains(string a, char b) {
  int i = 0;
  while (i < a.length && a[i] < b)
    ++i;
  return i < a.length && a[i] == b;
}

void main() {
  File input = File("input.txt", "r");
  string line = input.readln.chomp;
  int ans = 0;
  while (!line.empty()) {
    int delimiter = line.indexOf("|");

    string[] usp = line[0 .. delimiter - 1].split;
    for (int i = 0; i < usp.length; ++i) {
      char[] s = usp[i].dup;
      s.representation.sort;
      usp[i] = s.to!string;
    }

    string[] out_nums = line[delimiter + 2 .. $].split;
    for (int i = 0; i < out_nums.length; ++i) {
      char[] s = out_nums[i].dup;
      s.representation.sort;
      out_nums[i] = s.to!string;
    }

    string[10] nums;
    foreach (string num; usp)
      if (num.length == 2)
        nums[1] = num;
      else if (num.length == 4)
        nums[4] = num;
      else if (num.length == 3)
        nums[7] = num;
      else if (num.length == 7)
        nums[8] = num;

    foreach (string num; usp)
      if (num.length == 5 && num.contains(nums[7]))
        nums[3] = num;
      else if (num.length == 6 && !num.contains(nums[1]))
        nums[6] = num;

    char segment_f;
    foreach (char c; nums[1])
      if (nums[6].contains(c))
        segment_f = c;

    foreach (string num; usp)
      if (num.length == 5 && num != nums[3])
        if (num.contains(segment_f))
          nums[5] = num;
        else
          nums[2] = num;

    char segment_e;
    foreach (char c; nums[2])
      if (!nums[5].contains(c) && !nums[1].contains(c))
        segment_e = c;

    foreach (string num; usp)
      if (num.length == 6 && num != nums[6])
        if (num.contains(segment_e))
          nums[0] = num;
        else
          nums[9] = num;

    int[string] m;
    for (int i = 0; i < 10; ++i)
      m[nums[i]] = i;

    int[] output = out_nums.map!(x => m[x]).array;

    for (int i = 0; i < 4; ++i)
      ans += output[i] * 10 ^^ (3 - i);

    line = input.readln.chomp;
  }
  ans.writeln;
}
