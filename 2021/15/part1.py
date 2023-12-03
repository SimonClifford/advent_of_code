import fileinput
import numpy as np

if __name__ == '__main__':
    f = fileinput.input()

    # get sizes
    max_x = 0
    max_y = 0
    for line in f:
        line = line.strip()
        max_y = len(line)
        max_x += 1

    big_arr = np.zeros( (max_x,max_y), dtype=np.byte )
    cost_arr = np.array(big_arr)

    f.close()
    f = fileinput.input()

    for x, line in enumerate(f):
        line = line.strip()
        for y, c in enumerate(line):
            big_arr[x, y] = int(c)

    print (big_arr)

    print (max_x + max_y - 1)
