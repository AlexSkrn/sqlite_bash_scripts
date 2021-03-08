import os

import xml.etree.ElementTree as ET
import pprint


tree = ET.parse(os.path.join('data', 'exampleresearcharticle.xml'))
root = tree.getroot()

print('Childred in root')
for child in root:
    print(child.tag)

# Childred in root
# ui
# ji
# fm
# bdy
# bm


title = root.find('./fm/bibl/title')
title_text = ''
for p in title:
    title_text += p.text

print()
