import fileinput

def main():
    lista = []
    listb = []
    tot1 = 0
    for l in fileinput.input():
        a, b = map(int, l.split())
        lista.append(a)
        listb.append(b)
    for a, b in zip(sorted(lista), sorted(listb)):
        tot1 += abs(a-b)

    tot2 = 0
    for a in lista:
        tot2 += a * listb.count(a)
        
    print(f"Part 1 total {tot1}")
    print(f"Part 2 total {tot2}")

if __name__ == "__main__":
    main()
