import sys
import fileinput

good = 0
pws = []
for l in fileinput.input():
    l = l.rstrip()
    pws.append( l.split(' ') )

for i in pws:
    low, upp = [int (x) for x in i[0].split('-')]
    s = i[1].rstrip(':')
    if ((i[2][low-1] == s) != (i[2][upp-1] == s)):
        good = good + 1

print (good)
