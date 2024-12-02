import fileinput
import itertools


def is_safe(arr):
    diffs = list(map(lambda x: int(x[1])-int(x[0]), itertools.pairwise(arr)))
    if any(map(lambda x: abs(x) < 1 or abs(x) > 3, diffs)):
        return False
    if not all(map(lambda x: x > 0, diffs)) and \
            not all(map(lambda x: x < 0, diffs)):
        return False
    return True


def remove_one(arr):
    for i in range(len(arr)):
        yield arr[0:i] + arr[i+1:]


def check_arr(arr):
    for sub_arr in remove_one(arr):
        if is_safe(sub_arr):
            return True
    return False


def main():
    tot = 0
    for line in fileinput.input():
        arr = line.split()
        if check_arr(arr):
            tot += 1

    print(f"Part 2 total: {tot}")


if __name__ == "__main__":
    main()
