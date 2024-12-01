import numpy as np
import sys

class Node:
	def __init__(self,ch):
		self.visited = False
		self.ch = ch
	def traverse(self):
		if not self.visited:
			self.visited = True
			return 1
		return 0

class BeamSection:
	def __init__(self,startX,startY,xDirection,yDirection,parent):
		self.xPos = startX
		self.yPos = startY
		self.xVel = xVel
		self.yVel = yVel
		self.parent = parent
		self.value = 0


	def traverse(self):
		self.value += dataArray[self.xPos,self.yPos].traverse()
		self.xPos += self.xVel
		self.yPos += self.yVel
		if self.xPos > dataArray.shape[0]
			or self.xPos < 0
			or self.yPos > dataArray.shape[1]
			or self.yPos < 0:
			return self.value
		if dataArray[self.xPos,self.yPos] == ".":
			self.traverse()

	def slash(self):

	def backSlash(self):
		print("\\")

	def pipe(self):
		print("|")

	def hyphen(self):
		print("-")


with open (sys.argv[1]) as file:
	data = file.readlines()

dataArray = np.ndarray( (len(data), len(data[0])-1), dtype=Node)

for row in range(len(dataArray)):
	for pos in range(len(dataArray[0])):
		dataArray[row][pos] = Node(data[row][pos])

