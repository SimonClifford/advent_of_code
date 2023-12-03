import fileinput
import numpy as np
import sys

def display(arr):
    for r in arr:
        print ( ''.join([ '#' if v else ' ' for v in r ]))

if __name__ == '__main__':
    f = fileinput.input()

    # get sizes
    max_x = 0
    max_y = 0
    for line in f:
        if line == '\n':
            break
        line = line.strip()
        x, y = [ int(c) for c in line.split(',') ]
        max_x = max(max_x, x)
        max_y = max(max_y, y)

    big_arr = np.zeros( (max_y+1,max_x+1), dtype=np.byte )

    f.close()
    f = fileinput.input()
    for line in f:
        if line == '\n':
            break
        line = line.strip()
        x, y = [ int(c) for c in line.split(',') ]
        big_arr[y, x] = 1
    folds = []
    for line in f:
        line = line.strip()
        folds.append(line[11:])

    for fold in folds:
        if fold.startswith('y='):
            val = int(fold[2:])
            res = big_arr[0:val, :] | big_arr[:val:-1, :]
        elif fold.startswith('x='):
            val = int(fold[2:])
            res = big_arr[:, 0:val] | big_arr[:, :val:-1]
        else:
            sys.exit(1)
        big_arr = res
        print (np.unique(big_arr, return_counts=True)[1][1])
            
    display (res)

