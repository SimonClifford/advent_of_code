import fileinput

reps = {'F':'0', 'B':'1', 'R':'1', 'L':'0'}
mx = 0
for l in fileinput.input():
    l1 = l
    for old, new in reps.items():
        l1 = l1.replace(old, new)
    num = int(l1, 2)
    mx = max(mx, num)
print (mx)
