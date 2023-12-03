import sys
import fileinput
import re

f = open('input')

hcl_re = re.compile(r'#[0-9a-f]{6}$')
pid_re = re.compile(r'[0-9]{9}$')

def check_hgt(h):
    if h[-2:] == 'in':
        return 59<=int(h[:-2])<=76
    elif h[-2:] == 'cm':
        return 150<=int(h[:-2])<=193
    else:
        return False

verifs = {
    'byr': (lambda x: 1920<=int(x)<=2002),
    'iyr': (lambda x: 2010<=int(x)<=2020),
    'eyr': (lambda x: 2020<=int(x)<=2030),
    'hgt': (lambda x: check_hgt(x)),
    'hcl': (lambda x: hcl_re.match(x)),
    'ecl': (lambda x: x in set(('amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'))),
    'pid': (lambda x: pid_re.match(x)),
    'cid': (lambda x: True),
}

def verify_entry(s):
    d = { x[0]: x[1] for x in  [t.split(':') for t in s.split()] }
    d['cid'] = '1'
    checks = all( verifs[k](v) for k, v in d.items() )
    return checks and len(d) == 8

count = 0
st = ''
while True:
    l = f.readline()
    if l == '\n' or l=='':
        if verify_entry(st): count += 1
        print (st, verify_entry(st))
        st = ''
    else:
        st = st + l

    if l == '': break

print (count)

