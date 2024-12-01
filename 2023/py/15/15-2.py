import sys
from collections import OrderedDict 

boxes = [OrderedDict() for i in range(0,256)]

def HashIn(code):
	tot = 0
	for char in code:
		tot += ord(char)
		tot *= 17
		tot %= 256
	return tot

def equalsOp(hashCode, value):
	boxPos = HashIn(hashCode)
	boxes[boxPos][hashCode] = int(value)

def minusOp(hashCode):
	boxPos = HashIn(hashCode)
	if hashCode in boxes[boxPos]:
		del boxes[boxPos][hashCode]

with open (sys.argv[1]) as file:
	steps = file.readlines()[0].strip()
steps = steps.split(",")

for item in steps:
	if item.endswith("-"):
		minusOp(item[:-1])
	else:
		equalsOp(item[:-2],item[-1])

tot = 0
for pos, box in enumerate(boxes):
	for posD, lens in enumerate(box.values()):
		tot += (pos+1) * (posD+1) * lens
print(f"Total: {tot}")
