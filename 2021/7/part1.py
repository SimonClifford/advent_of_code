import fileinput

def summit(n):
    return int(n*(n+1)/2)

if __name__ == '__main__':
    f = fileinput.input()

    line = list(f)[0].strip()
    crabs = [ int(c) for c in line.split(',') ]

    best_posn = 0
    best_fuel = sum( [ summit(c) for c in crabs ] )

    for posn in range(min(crabs), max(crabs)+1):
        fuel = sum( [ summit(abs(c-posn)) for c in crabs ] )
        if fuel < best_fuel:
            best_fuel = fuel
            best_posn = posn

    print (best_fuel, best_posn)
