import fileinput
import numpy as np


def main():
    # Read input into ndarray.
    ar = np.array(list(map(lambda x: [z for z in x.strip("\n")],
                  fileinput.input())))

    tot1 = tot2 = 0
    for x in all_readings(ar):
        tot1 += x.count('XMAS')

    print(f"Part 1 answer {tot1}")

    for r in range(1, ar.shape[0]-1):
        for c in range(1, ar.shape[1]-1):
            if ar[r, c] == 'A' and is_x_mas(ar, r, c):
                tot2 += 1

    print(f"Part 2 answer {tot2}")


def is_x_mas(arr, row: int, col: int):
    """
    Given the position row, col in arr, where there is an A,
    check to see if it's got two M's and 2 S's in the right places
    """
    try:
        checks = {'M', 'S'}
        for offset in ((row-1, col-1), (row+1, col+1)):
            checks.remove(arr[offset])
        checks = {'M', 'S'}
        for offset in ((row+1, col-1), (row-1, col+1)):
            checks.remove(arr[offset])
    except KeyError:
        return False
    return True


def all_readings(arr):
    """
    Generator to provide all legit readings of an array.
    So [ X Y Z
         1 2 3
         A B C ]
    will output XYZ, 123, ABC, X1A, Y2B, Z3C, X, Y1, Z2A, ...
    Diag indices
    [0,0] [0,1 1,0] [0,2 1,1 2,0] [1,2 2,1] [2,2]
    [0,2] [0,1 1,2] [0,0 1,1 2,2] [1,0 2,1] [2,0]
    """
    maxr = arr.shape[0]
    maxc = arr.shape[1]
    # Do rows
    for row in range(maxr):
        yield ''.join(arr[row, :])
        yield ''.join(arr[row, -1::-1])

    # Do columns
    for col in range(maxc):
        yield ''.join(arr[:, col])
        yield ''.join(arr[-1::-1, col])

    # Do diagonals
    for s in [arr.diagonal(off) for off in range(-maxr+1, maxr)]:
        yield ''.join(s)
        yield ''.join(s[-1::-1])

    arr2 = arr[:, -1::-1]
    for s in [arr2.diagonal(off) for off in range(-maxr+1, maxr)]:
        yield ''.join(s)
        yield ''.join(s[-1::-1])


if __name__ == "__main__":
    main()
