import os
import csv
import pprint


DATADIR = 'data'
DATAFILE = 'beatles-discography.csv'


def parse_csv(datafile: str) -> list:
    data = []
    with open(datafile, 'r') as sd:
        r: dict = csv.DictReader(sd)
        for line in r:
            data.append(line)
    return data


if __name__ == '__main__':
    datafile = os.path.join(DATADIR, DATAFILE)
    d = parse_csv(datafile)
    pprint.pprint(d)
