import std.stdio;
import std.string;
import std.ascii : isDigit;

int idx;
int version_sum;

ubyte char_to_hex(char c) {
  if (c.isDigit)
    return cast(ubyte)(c - '0');
  return cast(ubyte)(c - 'A' + 10);
}

ubyte get_bit(const ref string line, int i) {
  int char_idx = i / 4;
  int half_byte = line[char_idx].char_to_hex;
  return (half_byte >> (3 - (i % 4))) & 1;
}

uint get_bits(const ref string line, int n) {
  uint result = 0;
  for (int o = 0; o < n; ++o) // o stands for offset
    result |= line.get_bit(idx++) << (n - o - 1);
  return result;
}

void parse_packet(const ref string line) {
  int ver = line.get_bits(3);
  version_sum += ver;
  int type_id = line.get_bits(3);
  if (type_id == 4)
    line.parse_literal();
  else
    line.parse_operator();
}

void parse_literal(const ref string line) {
  int value = 0;
  ubyte prefix;
  do {
    prefix = line.get_bit(idx++);
    value <<= 4;
    value |= line.get_bits(4);
  }
  while (prefix);
}

void parse_operator(const ref string line) {
  ubyte length_type_id = line.get_bit(idx++);
  if (length_type_id == 0) {
    int length_subpackets = line.get_bits(15);
    int start = idx;
    while (idx < start + length_subpackets)
      line.parse_packet();
  } else {
    int number_of_subpackets = line.get_bits(11);
    while (number_of_subpackets--)
      line.parse_packet();
  }
}

void main() {
  File input = File("input.txt", "r");
  string line = input.readln.chomp;
  while (!line.empty) {
    idx = 0;
    version_sum = 0;
    line.parse_packet();
    version_sum.writeln;
    line = input.readln.chomp;
  }
}
