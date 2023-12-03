import fileinput

def count_incs(int_seq, window=1):
    num = 0
    for i in range(1, len(int_seq)-window+1):
        prev_sum = sum(int_seq[i-1: i+window-1])
        new_sum = sum(int_seq[i: i+window])
        if new_sum > prev_sum:
            num += 1
        print (prev_sum, new_sum, num)
    return num

if __name__ == '__main__':
    f = fileinput.input()
    vals = list(map(int, f))
    print (count_incs(vals, 3))
