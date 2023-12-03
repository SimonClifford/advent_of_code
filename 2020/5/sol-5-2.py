import fileinput

reps = {'F':'0', 'B':'1', 'R':'1', 'L':'0'}
mx = 0
#seats = set(range(0,990))
seats = set()
for l in fileinput.input():
    l1 = l
    for old, new in reps.items():
        l1 = l1.replace(old, new)
    num = int(l1, 2)
    seats.add(num)

for s in range(min(seats), max(seats)+1):
    if s not in seats:
        if s-1 in seats and s+1 in seats:
            print (s)
print (seats)
