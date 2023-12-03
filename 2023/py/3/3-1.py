import fileinput
import re
from typing import List

def main():
    '''
    The engine schematic (your puzzle input) consists of a visual
    representation of the engine. There are lots of numbers and symbols you
    don't really understand, but apparently any number adjacent to a symbol,
    even diagonally, is a "part number" and should be included in your sum.
    (Periods (.) do not count as a symbol.)

    Here is an example engine schematic:

    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..

    In this schematic, two numbers are not part numbers because they are not
    adjacent to a symbol: 114 (top right) and 58 (middle right). Every other number
    is adjacent to a symbol and so is a part number; their sum is 4361.

    Of course, the actual engine schematic is much larger. What is the sum of all
    of the part numbers in the engine schematic? 
    '''
    file_to_read = fileinput.input()

    # We'll hold three lines in buffers
    linebuffer: List[str] = ['', '', '']

    # Deal with first line
    linebuffer[1] = file_to_read.readline().strip()
    linebuffer[2] = file_to_read.readline().strip()
    line_length = len(linebuffer[1])
    linebuffer[0] = '.' * line_length

    total = 0
    while linebuffer[2]:

        total += find_numbers(linebuffer, line_length)

        linebuffer[0] = linebuffer[1]
        linebuffer[1] = linebuffer[2]
        linebuffer[2] = file_to_read.readline().strip()

    linebuffer[2] = '.' * line_length
    total += find_numbers(linebuffer, line_length)

    print('Total: ', total)

def find_numbers(lines: List[str], line_length: int) -> int:
    '''
    Given lines, find and process the current line
    '''
    re_digits = re.compile(r'(\d+)')
    total = 0
    index = 0
    while index < line_length:
        if m := re_digits.match(lines[1], index):
            if check_surrounds(lines, index, len(m[1]), line_length):
                total += int(m[1])
                index += len(m[1])
        index += 1
    return total


def check_surrounds(lines: List[str], i: int, length: int,
    line_length: int) -> bool:
    '''
    Given the buffer, and an index into the [1] line, and a length of
    a number, return True if any of the surrounding elements are symbols
    (i.e. not digits or '.').  False otherwise.

    This routine will account for going off the ends of the lines.
    '''
    for vertical_index in (-1, 0, 1):
        for horiz_index in range(max(0, i-1), min(line_length, i+length+1)):
            if re.match(r'[^\d.]', lines[vertical_index][horiz_index]):
                return True
    return False

if __name__ == '__main__':
    main()
