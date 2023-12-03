import sys

f = open('input')

count = 0
st = ''
while True:
    l = f.readline()
    if l == '\n' or l=='':
        count += len(set(st))
        st = ''
    else:
        st = st + l.rstrip()

    if l == '': break

print (count)
