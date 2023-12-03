import fileinput
import re


def main():
    '''
    Your calculation isn't quite right. It looks like some of the digits are
    actually spelled out with letters: one, two, three, four, five, six, seven,
    eight, and nine also count as valid "digits".

    Equipped with this new information, you now need to find the real first and
    last digit on each line. For example:

    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen

    In this example, the calibration values are 29, 83, 13, 24, 42, 14, and 76.
    Adding these together produces 281.
    '''
    tot = 0
    for line in fileinput.input():
        print(line)
        line = extract_nums(line)
        print(line)
        nums_only = [c for c in line if c.isdecimal()]
        calibration_value = f'{nums_only[0]}{nums_only[-1]}'
        tot += int(calibration_value)

    print(f'Total is {tot}\n')


def extract_nums(s: str) -> str:
    '''
    Given a string like 7pqrstsixteen return a string where the spelled out
    numbers have been replaced with digits.
    '''
    digits = {
        'one': '1', 'two': '2', 'three': '3', 'four': '4', 'five': '5',
        'six': '6', 'seven': '7', 'eight': '8', 'nine': '9',
    }
    out_str = ''
    i = 0
    while i < len(s):
        for d in digits:
            if re.match(d, s[i:]):
                out_str = out_str + digits[d]
                i += 1
                break
        out_str = out_str + s[i]
        i += 1
    return out_str

if __name__ == '__main__':
    main()
