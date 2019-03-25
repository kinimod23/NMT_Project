#!/usr/bin/env python


# Converts original wmt'17 task's corpus into a glove readable text file
# without punctuation
# without newlines \n

import sys
import string

corp_file = sys.argv[1]

with open(corp_file, 'r', encoding = 'utf-8') as corp:
    wmt = corp.read().lower()

    translate_table = dict((ord(char), None) for char in string.punctuation)   
    wpwmt = wmt.translate(translate_table)

    nwpwmt = wpwmt.replace("\n", " ")

with open("gloved_" + corp.name.rsplit('/', 1)[-1], "w", encoding="utf-8") as file:
    file.write(nwpwmt)

