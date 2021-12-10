import std.stdio;
import std.string;
import std.typecons;
import std.algorithm;

char get(string[] data, int i, int j) {
    if (i < 0 || j < 0 || i >= data.length || j >= data[i].length)
        return 'A';
    return data[i][j];
}

Tuple!(int, int) find_lowpoint(string[] data, int[Tuple!(int, int)] m, int i, int j) {
    if (tuple(i, j) in m)
        return tuple(i, j);
    int val = data.get(i-1, j);
    int y = i-1, x = j;
    if (data.get(i+1, j) < val) {
        val = data[i+1][j];
        y = i+1; x = j;
    }
    if (data.get(i, j+1) < val) {
        val = data[i][j+1];
        y = i; x = j+1;
    }
    if (data.get(i, j-1) < val) {
        val = data[i][j-1];
        y = i; x = j-1;
    }

    return data.find_lowpoint(m, y, x);
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
    int[Tuple!(int, int)] m;
    for (int i = 0; i < data.length; ++i)
        for (int j = 0; j < n; ++j)
            if (data[i][j] < data.get(i, j+1) &&
                data[i][j] < data.get(i, j-1) &&
                data[i][j] < data.get(i+1, j) &&
                data[i][j] < data.get(i-1, j))
                    m[tuple(i, j)] = 0;

    for (int i = 0; i < data.length; ++i)
        for (int j = 0; j < n; ++j) {
            if (data[i][j] == '9') continue;
            auto t = data.find_lowpoint(m, i, j);
            ++m[t];
        }
    
    int[] a = m.values;
    a.sort;
    writeln(a[$-1] * a[$-2] * a[$-3]);
}