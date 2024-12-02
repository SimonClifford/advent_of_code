import fileinput
import itertools


def main():
    tot = 0
    for line in fileinput.input():
        arr = line.split()
        diffs = list(map(lambda x: int(x[1])-int(x[0]),
                         itertools.pairwise(arr)))
        if any(map(lambda x: abs(x) < 1 or abs(x) > 3, diffs)):
            continue
        if not all(map(lambda x: x > 0, diffs)) and \
                not all(map(lambda x: x < 0, diffs)):
            continue

        tot += 1

    print(f"Part 1 total: {tot}")


if __name__ == "__main__":
    main()
