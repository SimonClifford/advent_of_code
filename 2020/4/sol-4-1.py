import sys
import fileinput

f = open('input')

def count_bits(s):
    d = { x[0]: x[1] for x in  [t.split(':') for t in s.split()] }
    d['cid'] = '1'
    return len(d) == 8

count = 0
st = ''
while True:
    l = f.readline()
    if l == '\n' or l=='':
        if count_bits(st): count += 1
        st = ''
    else:
        st = st + l

    if l == '': break

print (count)
