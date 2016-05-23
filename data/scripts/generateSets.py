#!/usr/bin/python3

import argparse
import mcStamps

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-n', '--numRuns', default=10, help='number of MC runs', type=int)
    args = parser.parse_args()

    for i in range(args.numRuns):
        print('generating run:',i)
        mcStamps.generateData('../run_'+str(i)+'.csv')

if __name__ == "__main__":
    main()

