#!/usr/bin/env python3

import re
import glob

def read_test_results(filename):
    res = []
    with open(filename, 'r') as f:
        for line in f:

            match = re.match('^#([0-9]+/[pu])(.*)\\b(OK|SKIP|FAIL)\\b', line)
            if match:
                testid = match[1]
                desc = match[2]
                result = match[3]
                res.append((testid, desc, result))
            else:
                assert not line.startswith('#'), line
    return res


def filter(d, result):
    return {x for x in d if x[2] == result}

res = {}

for name in glob.glob('*.log'):
    res[name.split('.')[0]] = read_test_results(name)

