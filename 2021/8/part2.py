import fileinput
from itertools import permutations
import sys

valid_sets = {'abcefg': '0', 'cf': '1', 'acdeg': '2', 'acdfg': '3', 'bcdf': '4', 'abdfg': '5',
    'abdefg': '6', 'acf':'7', 'abcdefg': '8', 'abcdfg': '9'}

def check_perms(inputs):
    for perm in permutations('abcdefg'):
        settings = dict(zip(perm, 'abcdefg'))
        if check_perm(inputs, settings):
            return settings
    raise(Exception)

def check_perm(inputs, settings):
#    print ('settings ', ''.join(settings.keys()))
    for p in inputs:
        parp = ''.join(sorted([ settings[s] for s in p ]))
#        print ('trying', p, '->', parp)
        if parp not in valid_sets:
            return False
    return True

def evaluate(outputs, settings):
    val = ''
    for o in outputs:
        o = sorted(o)
        parp = ''.join(sorted([ settings[s] for s in o ]))
        val += valid_sets[ parp ]
    return int(val)
        
if __name__ == '__main__':
    f = fileinput.input()

    tot = 0
    for line in f:
        line.strip()
        parts = []
        for p in line.split(' | '):
            parts.append( p.split() )
        settings = check_perms(parts[0])
        tot += evaluate(parts[1], settings)
    print (tot)
