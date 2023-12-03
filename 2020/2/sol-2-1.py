import sys
import fileinput

good = 0
pws = []
for l in fileinput.input():
    l = l.rstrip()
    pws.append( l.split(' ') )

for i in pws:
    low, upp = [int (x) for x in i[0].split('-')]
    cnt = i[2].count(i[1].rstrip(':'))
    if cnt >= low and cnt <= upp:
        good = good + 1

print (good)
