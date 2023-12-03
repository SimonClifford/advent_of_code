import fileinput
from itertools import repeat

if __name__ == '__main__':

    counts = []
    gamma = 0
    epsilon = 0

    for l in fileinput.input():
        l = l.strip()
        if not counts:
            counts = list(repeat(0, len(l)))
            pow2 = 2**(len(l)-1)
        for i, c in enumerate(l):
            counts[i] += int(c)
    num_lines = fileinput.filelineno()
    for i, v in enumerate(counts):
        bit = 1 if (v > num_lines/2) else 0
        print (i, bit, pow2)
        gamma += bit * pow2
        epsilon += (1-bit) * pow2
        pow2 >>= 1

    print ('gamma: {}, epsilon: {}, product: {}'.
        format(gamma, epsilon, gamma*epsilon))
