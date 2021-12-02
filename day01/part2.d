import std.stdio;
import std.conv;
import std.string;
import std.container;

void main() {
    File input = File("input.txt", "r");
    int count = 0;
    auto q = DList!int();
    int s = 0;
    for (int i = 0; i < 3; ++i) {
        int x = input.readln.chomp.to!int;
        q.insertBack(x);
        s += x;
    }
    int last = s;
    string line = input.readln.chomp;
    while (!line.empty()) {
        int current = line.to!int;
        q.insertBack(current);
        s += current;
        s -= q.front();
        q.removeFront();
        if (s > last)
            count++;
        last = s;
        line = input.readln.chomp;
    }
    count.writeln;
}