import fileinput
import functools
import operator

#skip first line, get length from it
inp = fileinput.input()
firstline = inp.readline().rstrip()
length = len(firstline)

index = [0, 0, 0, 0, 0] # 0 indexed
vmod = [1, 1, 1, 1, 2]
hdel = [1, 3, 5, 7, 1]
trees = [0, 0, 0, 0, 0]

for f in inp:
    for i in range(5):
        if (inp.lineno()-1)%vmod[i] == 0:
            index[i] = (index[i] + hdel[i])%length
            if f[index[i]] == '#': trees[i] += 1

print (trees, functools.reduce(operator.mul,trees))
