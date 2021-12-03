import std.stdio;

void main() {
    File input = File("input.txt", "r");
    string line = input.readln.chomp;
    while (!line.empty()) {
        line = input.readln.chomp;
    }
}