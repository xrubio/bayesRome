#!/usr/bin/python3

import re
# script to split a csv file between complete and imcomplete stamps

def splitNew():
    dataFile = '../parsed/expandedNewStamps.csv'
    completeFile = '../parsed/complete.csv'
    uncompleteFile = '../parsed/uncomplete.csv'


    myData = open(dataFile, 'r')
    complete = open(completeFile, 'w')
    uncomplete = open(uncompleteFile, 'w')

    # headers
    myData.readline()
    complete.write('stamp;dig\n')
    uncomplete.write('stamp;dig\n')
    for line in myData:
        parsedLine = line.strip().split(';')
        stamp = parsedLine[0]
        if '+' in stamp or '.' in stamp:
            uncomplete.write(line)
        else:
            complete.write(line)
    myData.close()
    complete.close()
    uncomplete.close()

def splitOld():
    dataFile = '../raw/oldStamps.csv'
    completeFile = '../parsed/complete.csv'
    uncompleteFile = '../parsed/uncomplete.csv'


    myData = open(dataFile, 'r')
    # header
    myData.readline()

    complete = open(completeFile, 'a')
    uncomplete = open(uncompleteFile, 'a')

    # headers
    myData.readline()
    for line in myData:
        parsedLine = line.strip().split(';')
        # old stamps csv is formatted as id;stamp
        stamp = parsedLine[1]
        if '+' in stamp or '.' in stamp:
            uncomplete.write(stamp+';old\n')
        else:
            complete.write(stamp+';old\n')
    myData.close()
    complete.close()
    uncomplete.close()

def main():
    splitNew()
    splitOld()

if __name__ == "__main__":
    main()

