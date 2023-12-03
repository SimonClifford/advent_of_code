import sys

f = open('input')

count = 0
peeps = []
while True:
    l = f.readline()
    if l == '\n' or l=='':
        count += len(set.intersection(*peeps) if peeps else set())
        peeps = []
    else:
        peeps.append(set(l.rstrip()))

    if l == '': break

print (count)
