import fileinput
import re
from typing import List, Tuple
import sys

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

        total += process_lines(linebuffer)

        linebuffer[0] = linebuffer[1]
        linebuffer[1] = linebuffer[2]
        linebuffer[2] = file_to_read.readline().strip()

    linebuffer[2] = '.' * line_length
    total += process_lines(linebuffer)

    print('Total: ', total)


def process_lines(linebuffer) -> int:
    star_regexp = re.compile(r'(\*)')
    num_regexp = re.compile(r'(\d+)')

    total = 0
    nums = []
    touching_nums = []
    for vertical_index in (0, 1, 2):
        nums.extend(find_thing(linebuffer[vertical_index], num_regexp))
    # nums now holds all numbers in the three lines

    for star in find_thing(linebuffer[1], star_regexp):
        touching_nums = [n for n in nums if check_overlap(star, n)]
        #print(star, touching_nums, len(touching_nums))
        if len(touching_nums) > 1:
            assert len(touching_nums) == 2
            total +=  int(touching_nums[0][0]) * int(touching_nums[1][0])

    
    return total


def find_thing(line: str, regexp) -> List[Tuple[str, int, int]]:
    '''
    Given line, find regexp in the line, return
    Tuple(thing_found, index, length)
    '''
    things_found: List[Tuple[str, int, int]] = []
    line_length = len(line)
    index = 0
    while index < line_length:
        if m := regexp.match(line, index):
            things_found.append((m[1], m.start(1), len(m[1])))
            index += len(m[1])
        else:
            index += 1
    return things_found


def check_overlap(star, num) -> bool:
    '''
    star and num are Tuple(str, int, int)

    e.g. ('*', 3, 1)
    or   ('35', 2, 2)

    first int is index in line, second is length

    We must check to see if this num overlaps this star's surround
    '''
    # is rightmost part of num to left of leftmost part of star
    if num[1] + num[2] < star[1]:
        return False
    # is leftmost part of num to right of rightmost part of star
    if num[1] > star[1] + 1:
        return False
    return True


if __name__ == '__main__':
    main()
