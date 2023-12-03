import fileinput

def count_incs(int_seq):
    num = 0
    for i in range(1, len(int_seq)):
        if int_seq[i] > int_seq[i-1]:
            num += 1
        print (int_seq[i-1], int_seq[i], num)
    return num

if __name__ == '__main__':
    f = fileinput.input()
    vals = list(map(int, f))
    print (count_incs(vals))
