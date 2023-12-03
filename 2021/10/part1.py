import fileinput
import sys

opens = { '{': '}', '[': ']', '(': ')', '<': '>' }
closes = { '}': '{', ']': '[', ')': '(', '>': '<' }
score = { '}': 1197, ']': 57, ')': 3, '>': 25137 }
def doit(line):
    stack = ''
    for c in line:
        if c in closes:
            if stack[-1] == closes[c]:
                stack = stack[:-1]
            elif stack[-1] in opens:
                print ('Expected {}, found {} instead'.format(
                    opens[stack[-1]], c))
                return c
        else:
            stack += c
#        print (stack)
    return None

if __name__ == '__main__':
    f = fileinput.input()

    tot = 0
    for line in f:
        line = line.strip()
        c = doit(line)
        if c:
            tot += score[c]

    print (tot)
