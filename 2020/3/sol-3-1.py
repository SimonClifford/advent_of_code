import fileinput

#skip first line, get length from it
inp = fileinput.input()
firstline = inp.readline().rstrip()
length = len(firstline)

index = 0 # 0 indexed
trees = 0
for f in inp:
    index = (index + 3) % length
    if f[index] == '#': trees += 1

print (trees)
