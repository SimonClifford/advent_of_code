import sys
import fileinput

nums = []
for num in fileinput.input():
    n = int(num)
    for m in nums:
        if n+m == 2020:
            print (n, " and ", m, " product is ", n*m)
            sys.exit()
    nums.append(n)
