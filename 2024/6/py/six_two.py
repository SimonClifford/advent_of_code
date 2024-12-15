import fileinput
import itertools
import numpy as np


class Looped(Exception):
    """
    When guard loops back on themself
    """


def read_input(filename=None):
    lines = [x.strip() for x in fileinput.input(filename)]
    arr = np.array([c for line in lines for c in line]).reshape(len(lines),
                                                                len(lines[0]))
    return arr


def is_inside(rc, arr):
    return rc[0] >= 0 and rc[0] < arr.shape[0] and rc[1] >= 0 and \
        rc[1] < arr.shape[1]


def add(rc, delta):
    return (rc[0] + delta[0], rc[1] + delta[1])


def main(filename=None):
    arr = read_input(filename)
    (r, c) = map(lambda x: int(x.squeeze()), np.where(arr == '^'))
    rc = (r, c)
    initial_route = proceed_from(arr, rc, (-1, 0))

    loop_pts = set()
    for block_pt, block_dir in initial_route[1:]:
        temp = arr[block_pt]
        arr[block_pt] = 'O'
        try:
            proceed_from(arr, rc, (-1, 0))
        except Looped:
            loop_pts.add(block_pt)
        arr[block_pt] = temp

    print(f"Tot: {len(loop_pts)}")


def proceed_from(arr, rc, cur_dir):
    visit_set = set()
    visit_set.add((rc, cur_dir))
    past_route = [(rc, cur_dir)]

    # Directions
    #                up      rt        dn      lf
    directions = [(-1, 0), (0, +1), (+1, 0), (0, -1)]
    dir_iter = itertools.cycle(directions)
    while dir_iter.__next__() != cur_dir:
        pass

    while(True):
        new_rc = add(rc, cur_dir)

        if not is_inside(new_rc, arr):
            return past_route

        # print(f"Condidering {new_rc}")
        if arr[new_rc] == '#' or arr[new_rc] == 'O':
            cur_dir = dir_iter.__next__()
            # print(f"Turned to {cur_dir}")
            continue

        # If looping
        if (new_rc, cur_dir) in visit_set:
            raise Looped

        visit_set.add((new_rc, cur_dir))
        past_route.append((new_rc, cur_dir))
        rc = new_rc


if __name__ == '__main__':
    main()
