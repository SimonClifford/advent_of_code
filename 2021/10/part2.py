import fileinput
import sys

opens = { '{': '}', '[': ']', '(': ')', '<': '>' }
closes = { '}': '{', ']': '[', ')': '(', '>': '<' }
score = { '{': 3, '[': 2, '(': 1, '<': 4 }
def doit(line):
    stack = ''
    for c in line:
        if c in closes:
            if stack[-1] == closes[c]:
                stack = stack[:-1]
            elif stack[-1] in opens:
                return None
        else:
            stack += c
#        print (stack)
#    print ('need: ', ''.join( [ opens[x] for x in stack[::-1] ] ))
    return stack

if __name__ == '__main__':
    f = fileinput.input()

    scores = []
    for line in f:
        line = line.strip()
        c = doit(line)
        if c:
            this_tot = 0
            for x in c[::-1]:
                this_tot = this_tot*5 + score[x]
#            print (this_tot)
            scores.append( this_tot )

    scores.sort()
    print (scores, scores[len(scores)//2])

