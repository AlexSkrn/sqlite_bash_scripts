import os
from bs4 import BeautifulSoup
import requests

s = requests.Session()

url = "https://www.transtats.bts.gov/Data_Elements.aspx?Data=2"
r = s.get(url, verify=False)
soup = BeautifulSoup(r.text, features="lxml")
viewstate = soup.find(id="__VIEWSTATE")["value"]
eventvalidation = soup.find(id="__EVENTVALIDATION")["value"]
viewstategenerator = soup.find(id="__VIEWSTATEGENERATOR")["value"]

# print(viewstate[:20])
# print(viewstategenerator[:20])
# print(eventvalidation[:20])
# print(r.headers)


r = s.post(
    url,
    data=(
        ("__EVENTTARGET", ""),
        ("__EVENTARGUMENT", ""),
        ("__VIEWSTATE", viewstate),
        ("__VIEWSTATEGENERATOR", viewstategenerator),
        ("__EVENTVALIDATION", eventvalidation),
        ("CarrierList", "All"),
        ("AirportList", "All"),
        ("Submit", "Submit")
        )
    )

# print(r.headers)
print(r.status_code)

with open(os.path.join('data', "data_elements_results.html"), "w") as to_f:
    to_f.write(r.text)
