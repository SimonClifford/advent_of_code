import fileinput

if __name__ == '__main__':
    f = fileinput.input()
    line = list(f)[0]
    fishes = [0, 0, 0, 0, 0, 0, 0, 0, 0]

    for num in line.split(','):
        num = int(num)
        fishes[num] += 1

    print (fishes, sum(fishes))

    for i in range(256):
        new_fishes = list(fishes[1:9])
        new_fishes.append(fishes[0])
        new_fishes[6] += fishes[0]
        fishes = new_fishes
        print (i+1, fishes, sum(fishes))
