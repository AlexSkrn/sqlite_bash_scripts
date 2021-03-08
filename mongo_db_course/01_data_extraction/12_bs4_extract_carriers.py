"""Extract aiport & carrier codes from saved html."""

import os
from bs4 import BeautifulSoup


def options(soup, id):
    option_values = []
    carrier_list = soup.find(id=id)
    for option in carrier_list.find_all('option'):
        option_values.append(option['value'])
    return option_values


def print_list(label, codes):
    print(f'\n{label}')
    for c in codes:
        print(c)


def main():
    path = os.path.join('data', 'data_elements.html')
    soup = BeautifulSoup(open(path))

    codes = options(soup, 'CarrierList')
    print_list('Carriers', codes)

    codes = options(soup, 'AirportList')
    print_list('Airports', codes)


main()
