import fileinput

if __name__ == '__main__':
    pos = [ 0, 0 ]
    for l in fileinput.input():
        instruct, value = l.strip().split()
        value = int(value)
        if instruct == 'forward':
            pos[0] += value
        elif instruct == 'down':
            pos[1] += value
        elif instruct == 'up':
            pos[1] -= value
    print ('Final position, ', pos[0], ' final depth ', pos[1])
    print ('Answer: ', pos[0] * pos[1])
