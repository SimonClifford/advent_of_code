import fileinput
import numpy as np

def gen_inds(st, end):
    beg = list(st)
    yield beg[0], beg[1]
    while beg[0] != end[0] or beg[1] != end[1]:
        if beg[0] > end[0]:
            beg[0] -= 1
        elif beg[0] < end[0]:
            beg[0] += 1
        if beg[1] > end[1]:
            beg[1] -= 1
        elif beg[1] < end[1]:
            beg[1] += 1
        yield beg[0], beg[1]
    
if __name__ == '__main__':
    f = fileinput.input()
    big_arr = np.zeros( (1000,1000) )

    for line in f:
        st, end = line.split(' -> ')
        st0, st1 = [ int(x) for x in st.split(',') ]
        end0, end1 = [ int(x) for x in end.split(',') ]

        print (line)
        if st0 == end0 or st1 == end1:
            for b in gen_inds((st0, st1), (end0, end1)):
                print (b[0], b[1])
                big_arr[b[0]][b[1]] += 1

    _, occurs = np.unique(big_arr, return_counts=True)
    print (occurs)
    print (sum(occurs[2:]))

