import fileinput
import numpy as np

def is_lowest(arr, x, y):
    #print ('checking ', x, y, arr[x, y], arr.shape)
    if x > 0 and arr[x-1,y] <= arr[x,y]: 
        return False
    if y > 0 and arr[x,y-1] <= arr[x,y]:
        return False
    if x < arr.shape[0]-1 and arr[x+1,y] <= arr[x,y]:
        return False
    if y < arr.shape[1]-1 and arr[x,y+1] <= arr[x,y]:
        return False
    #print ('lowest')
    return True

if __name__ == '__main__':
    f = fileinput.input()

    hmap = np.empty( (100,100), dtype=np.byte )
    for l_no, line in enumerate(f):
        line = line.strip()
        hmap[l_no] = [ int(d) for d in line ]

    tot = 0
    print (hmap.shape,'\n', hmap)
    for x in range(hmap.shape[0]):
        for y in range(hmap.shape[1]):
            if is_lowest(hmap, x, y):
                tot += hmap[x,y] + 1
    print (tot)
