import csv
import MongoClient

client = MongoClient("mongodb://localhost:27017")
db = client.examples


def skip_lines(input_file, skip):
    for i in range(0, skip):
        next(input_file)


def audit_country(input_file):
    for row in input_file:
        country = row['country_label'].strip()
        if country == 'NULL' or country == '':
            continue
        if db.countries.find({'name': country}).count() != 1:
            print(f'Not found: {country}')


if __name__ == '__main__':
    input_file = csv.DictReader(open('cities.csv'))
    skip_lines(input_file, 3)
    audit_country(input_file)
