import fileinput
import re

regexp = re.compile(r"mul\((\d{1,3},\d{1,3})\)")


def do_muls(line):
    tot = 0
    for matched in regexp.findall(line):
        x, y = map(int, matched.split(','))
        tot += x * y
    return tot


def main():
    tot1 = tot2 = 0
    lines = fileinput.input()
    for line in lines:
        tot1 += do_muls(line)

    print(f"Part 1 answer: {tot1}")

    fileinput.close()
    lines = fileinput.input()
    joined_lines = ''.join(lines)
    for mat in re.split(r"do\(\)", joined_lines):
        do_bit = re.split(r"don't\(\)", mat)[0]
        tot2 += do_muls(do_bit)

    print(f"Part 2 answer: {tot2}")


if __name__ == "__main__":
    main()
