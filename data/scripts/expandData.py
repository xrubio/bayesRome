#!/usr/bin/python3

def main():
    dataFile = '../raw/newStamps.csv'
    outFile = '../parsed/expandedNewStamps.csv'

    myData = open(dataFile, 'r')
    output = open(outFile, 'w')

    # headers
    myData.readline()
    output.write('stamp;dig\n')
    for line in myData:
        parsedLine = line.strip().split(';')
        stamp = parsedLine[0]
        reps = int(parsedLine[1])
        dig = parsedLine[2]
        for i in range(reps):
            output.write(stamp+';'+dig+'\n')
    myData.close()
    output.close()

if __name__ == "__main__":
    main()

