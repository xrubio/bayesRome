#!/usr/bin/python3

import re, random
from collections import defaultdict

notFound = 0
found = 0

def getPossible(stamp, complete):
    # change '.' for '\w' (1 letter)
    stamp = stamp.replace('.','\w')
    # change '*' for '\w+' (1 or more)
    stamp = stamp.replace('+','\w+')
    # compute if it matches and it is complete (all the word)
    match = re.match(stamp,complete)
    if not match:
        return False
    if match.span()[1]==len(complete):
        return True
    return False

def getPossibleStamps(stamp, completeStamps):
    values = list()
    for complete in completeStamps:
        if getPossible(stamp, complete):
            values.append(complete)
    return values

def getNewValue(stamp, completeStamps):
    candidates = getPossibleStamps(stamp, completeStamps)
    global notFound
    global found

    # no candidate, keep original
    if len(candidates)==0:
        notFound += 1
#        print(stamp,'does not have any parallel')
        return stamp
    found += 1        
    # 1 option        
#   print(stamp,'candidates:',len(candidates),candidates)
    if len(candidates)==1:
        return candidates[0]
    # >1, random choice        
    return random.sample(candidates, k=1)[0]        

def getUniqueStamps(fileName):
    stamps = list()
    dataset = open(fileName, 'r')
    # skip header 
    dataset.readline()
    for line in dataset:
        # stamp is first word of line
        stamp = line.strip().split(';')[0]
        # if it is not already in list add it
        if stamp in stamps:
            continue
        stamps.append(stamp)
    dataset.close()
    return stamps

def generateData( outputFile ):
    completeFile = '../parsed/complete.csv'
    uncompleteFile = '../parsed/uncomplete.csv'

    completeStamps = getUniqueStamps(completeFile)

    # complete to reconstructed
    reconstructed = open(outputFile, 'w')
    reconstructed.write(open(completeFile,'r').read())


    uncomplete = open(uncompleteFile, 'r')
    # header
    uncomplete.readline()
    for line in uncomplete:
        stripped = line.strip().split(';')
        stamp = stripped[0]
        dig = stripped[1]
        newStamp = getNewValue(stamp, completeStamps)
        reconstructed.write(newStamp+';'+dig+'\n')
    reconstructed.close()
    global found
    global notFound 
    print('found:',found,'not found:',notFound)
    notFound = 0
    found = 0

def main():
    generateData('../singleRun.csv')

if __name__ == "__main__":
    main()

