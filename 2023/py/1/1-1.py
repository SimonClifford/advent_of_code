import fileinput


def main():
    '''
    On each line, the calibration value can be found by combining the first
    digit and the last digit (in that order) to form a single two-digit number.

    For example:

    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet

    In this example, the calibration values of these four lines are 12, 38, 15,
    and 77. Adding these together produces 142.
    '''
    tot = 0
    for line in fileinput.input():
        nums_only = [c for c in line if c.isdecimal()]
        calibration_value = f'{nums_only[0]}{nums_only[-1]}'
        tot += int(calibration_value)

    print(f'Total is {tot}\n')

if __name__ == '__main__':
    main()
