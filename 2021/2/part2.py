import fileinput

if __name__ == '__main__':
    pos = [ 0, 0 ]
    aim = 0
    for l in fileinput.input():
        instruct, value = l.strip().split()
        value = int(value)
        if instruct == 'forward':
            pos[0] += value
            pos[1] += value * aim
        elif instruct == 'down':
            aim += value
        elif instruct == 'up':
            aim -= value
    print ('Final position, ', pos[0], ' final depth ', pos[1])
    print ('Answer: ', pos[0] * pos[1])
