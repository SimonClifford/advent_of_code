import fileinput
import numpy as np
import sys
import functools
import operator

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

def ret_non_nine(arr, x, y):
    #print ('checking ', x, y, arr[x, y], arr.shape)
    points = set()
    if x > 0 and arr[x-1,y] != 9: 
        points.add( (x-1, y) )
    if y > 0 and arr[x,y-1] != 9:
        points.add( (x, y-1) )
    if x < arr.shape[0]-1 and arr[x+1,y] != 9:
        points.add( (x+1, y) )
    if y < arr.shape[1]-1 and arr[x,y+1] != 9:
        points.add( (x, y+1) )
    #print ('lowest')
    return points

if __name__ == '__main__':
    f = fileinput.input()

    hmap = np.empty( (100,100), dtype=np.byte )
    for l_no, line in enumerate(f):
        line = line.strip()
        hmap[l_no] = [ int(d) for d in line ]

    tot = 0
    print (hmap.shape,'\n', hmap)
    lowest_points = []
    for x in range(hmap.shape[0]):
        for y in range(hmap.shape[1]):
            if is_lowest(hmap, x, y):
                lowest_points.append( (x,y) )
    print (lowest_points, 'Start\n')

    # start with each lowest point and expand.

    basin_size = []
    for p in lowest_points:
        all_points = { p }
        new_points = { p }
        while new_points:
            newer_points = set()
            for np in new_points:
                points = ret_non_nine(hmap, *np)
                for pp in points:
                    newer_points.add( pp )
            new_points = newer_points.difference(all_points)
            for pp in new_points:
                all_points.add( pp )
        print(p, len(all_points))
        basin_size.append( len(all_points) )

    basin_size.sort()
    print (functools.reduce( operator.mul, basin_size[-3:] ))
