from collections import defaultdict
import fileinput
import functools
from itertools import pairwise


class Node:
    def __init__(self):
        self.before = set()
        self.after = set()


def main():
    """
    """
    global pages
    pages, updates = read_input()

    tot1 = tot2 = 0
    for upd in updates:
        if legit(upd, pages):
            tot1 += int(upd[len(upd)//2])
        else:
            new_up = sorted(upd, key=functools.cmp_to_key(compare_updates))
            tot2 += int(new_up[len(new_up)//2])

    print(f"Part 1 answer: {tot1}")
    print(f"Part 2 answer: {tot2}")


def compare_updates(u1, u2):
    if u1 in pages[u2].before:
        return +1
    elif u2 in pages[u1].before:
        return -1
    else:
        return 0


def legit(up, pages):
    for p in pairwise(up):
        if p[1] not in pages[p[0]].before:
            return False
    return True


def read_input(filename=None):
    pages = defaultdict(Node)
    inp = fileinput.input(filename)
    for line in inp:
        if line == "\n":
            break
        first, last = line.strip().split('|')
        pages[first].before.add(last)
#        pages[last].after.add(first)

    updates = []
    for line in inp:
        updates.append(
            line.strip().split(',')
        )

    return pages, updates


if __name__ == "__main__":
    main()
