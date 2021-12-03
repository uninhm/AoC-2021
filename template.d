import std.stdio;
import std.string;

void main() {
    File input = File("input.txt", "r");
    string line = input.readln.chomp;
    while (!line.empty()) {
        line = input.readln.chomp;
    }
}