import fileinput
from collections import Counter

if __name__ == '__main__':
    f = fileinput.input()

    trans_pairs = {}
    for line in f:
        line = line.strip()
        if f.isfirstline():
            template = line
            continue
        if line == '':
            continue
        p, i = line.split(' -> ')
        trans_pairs[p] = i

    print (trans_pairs)

    counter = Counter()
    tot_counter = Counter(template)
    for i in range(len(template)-1):
        pair = template[i:i+2]
        counter.update((pair,))
    print ('Template:    ', template)
    print ('Pairs:    ', counter)
    print ('Total:    ', tot_counter)

    for it in range(40):
        new_counter = Counter(counter)
        for p, count in counter.items():
            if not count:
                continue
            x = trans_pairs[p]
#            print (p, p[0]+x, x + p[1], count )
            new_counter[p[0] + x] += count
            new_counter[x + p[1]] += count
            new_counter[p] -= count
            tot_counter[x] += count
        counter = new_counter
        print(it, counter)

    ans = tot_counter.most_common()[0][1] - tot_counter.most_common()[-1][1]
    print(tot_counter, ans)

