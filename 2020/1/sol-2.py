import sys
import fileinput

nums = []
for num in fileinput.input():
    n = int(num)
    nums.append(n)

for i in range(0,len(nums)):
    for j in range(i+1,len(nums)):
        for k in range(j+1,len(nums)):
            if nums[i] + nums[j] + nums[k] == 2020:
                print (nums[i], ', ',nums[j], ' ', nums[k], 'add to 2020, mult to ', nums[i]*nums[j]*nums[k])
                sys.exit()
