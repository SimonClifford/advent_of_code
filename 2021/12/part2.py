import fileinput
from collections import Counter

class Cave:
    def __init__(self, name):
        self.name = name
        self.is_small = name.islower()
        self.connections = set()

    def add_connection(self, cave):
        self.connections.add(cave)

    def __str__(self):
        s = self.name + ':' + ','.join([ c.name for c in self.connections ])
        return s

    def __repr__(self):
        return self.name

def get_paths(current_path):
    '''
    Given a oath return an iterator over all possible completions
    of that path.
    '''
#    print('entered with', current_path, current_path[-1].connections)
    for c in current_path[-1].connections:
#        print('  ->', c.name, c.is_small, c in current_path)
        if c.is_small and c in current_path:
            if current_path.count(c) > 1:
                continue
            counts = Counter(current_path)
#            print (counts)
            if any( [ x>1 for k,x in counts.items() if k.is_small ]):
                continue
        if c.name == 'start':
            continue
#            print ('  bailing')
        new_path = list(current_path)
        new_path.append(c)
#        print('checking ', new_path)
        if c.name == 'end':
            yield new_path
        else:
            for p in get_paths(new_path):
                yield p

if __name__ == '__main__':
    f = fileinput.input()

    caves = {}
    for line in f:
        line = line.strip()
        a, b = line.split('-')
        for x in (a, b):
            if x not in caves:
                c = Cave(x)
                caves[x] = c
        cave_a, cave_b = [ caves[x] for x in (a, b) ]
        cave_a.add_connection(cave_b)
        cave_b.add_connection(cave_a)

    start_path = list( (caves['start'], ) )
    all_paths = list(get_paths(start_path))
    print(len(all_paths))
#    for p in all_paths:
#        print(p)

