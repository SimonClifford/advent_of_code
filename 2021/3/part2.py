import fileinput
import sys
from itertools import repeat

'''
structure = ( [ structure, structure, ...], [ structure, structure, ...] )
'''

def bit_count(seq, posn):
    '''
    Looks through a sequence of bit strings examining each element s
    counting s[posn].  Returns most common bit or 1 if equal.
    '''
    tot = 0
    for c in seq:
        tot += int((c[posn]))
    num = len(seq)
    if tot >= num-tot:
        return 1
    else:
        return 0

if __name__ == '__main__':

    f = fileinput.input()
    lines = [ l.strip() for l in f ]

    values = []
    for which in (0, 1):
        seq = lines
        bit_pos = 0
        while len(seq) > 1:
#            print (seq, len(seq), bit_pos)
            bit = bit_count(seq, bit_pos)
            bit = str(1-bit) if which else str(bit)
#            print (bit)
            seq = list(filter((lambda s: s[bit_pos] == bit), seq))
            bit_pos += 1
        values.append(int(seq[0], 2))

    print ('O2: {}, CO2: {}, Life support: {}'.
        format(values[0], values[1], values[0]*values[1]))

    sys.exit(0)
