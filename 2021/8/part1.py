import fileinput

if __name__ == '__main__':
    f = fileinput.input()

    counts = { 2: 0, 3:0, 4: 0, 7:0 }
    for line in f:
        line.strip()
        output = line.split(' | ')[1]
        outputs = output.split()
        for o in outputs:
            out_len = len(o)
            if out_len in counts:
                counts[out_len] += 1

    print (counts, sum(counts.values()))


