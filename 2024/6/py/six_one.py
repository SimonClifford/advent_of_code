import fileinput
import itertools
import numpy as np


def read_input(filename=None):
    lines = [x.strip() for x in fileinput.input(filename)]
    arr = np.array([c for l in lines for c in l]).reshape(len(lines),
                   len(lines[0]))
    return arr


def is_inside(rc, arr):
    return rc[0] >= 0 and rc[0] < arr.shape[0] and rc[1] >= 0 and rc[1] < arr.shape[1]


def add(rc, delta):
    return (rc[0] + delta[0], rc[1] + delta[1])


def process_1(arr):
    visited = np.zeros_like(arr, dtype=np.int8)
    (r, c) = map(lambda x: int(x.squeeze()), np.where(arr=='^'))
    rc = (r, c)
    visited[rc] = 1
#    visit_set = set()
#    visit_set.add(rc)

    # Directions
    #                up      rt        dn      lf
    directions = [(-1, 0), (0, +1), (+1, 0), (0, -1)]
    dir_iter = itertools.cycle(directions)
    cur_dir = dir_iter.__next__()

    while(is_inside(add(rc, cur_dir), arr)):
        new_rc = add(rc, cur_dir)
        print(f"Condidering {new_rc} tot {visited.sum()}")
        if arr[new_rc] == '#':
            cur_dir = dir_iter.__next__()
            print(f"Turned to {cur_dir}")
            continue

        visited[new_rc] = 1
#        visit_set.add(new_rc)
        rc = new_rc

    print(visited)
    print(visited.sum())
#    print(len(visit_set))
#    return visited, visit_set


def main(filename=None):
    arr = read_input(filename)
    process_1(arr)

if __name__ == '__main__':
    main()
