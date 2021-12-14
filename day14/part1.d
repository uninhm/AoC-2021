import std.stdio;
import std.string;
import std.format: formattedRead;
import std.algorithm: map, maxElement, minElement;
import std.array: array;
import std.conv: to;

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

    char[] ns;
    for (int step = 1; step <= 10; ++step) {
        ns = [];
        for (int i = 0; i+1 < s.length; ++i) {
            char[2] x = [s[i], s[i+1]];
            if (x in m)
                ns ~= [s[i], m[x]];
            else
                ns ~= x;
        }
        s = ns ~ s[$-1];
    }

    int[char] counter;
    foreach (char c; s)
        ++counter[c];

    writeln(counter.values.maxElement - counter.values.minElement);
}