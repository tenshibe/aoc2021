#!/usr/bin/python3
import sys

# general

inputfile = 'day1/input.txt'

# part 1

input1 = open(inputfile, 'r')
lowercount = 0
previousvalue = sys.maxsize

for inputline in input1:
    if int(inputline) > int(previousvalue):
        lowercount += 1
    previousvalue = inputline

print(f'The total number of dips is {lowercount}')

# part 2
measurements = []
slidercount = 0

with open(inputfile, 'r') as input2:
    measurements=list(input2)
for index, measurement in enumerate(measurements):
    if index > (len(measurements) - 4): 
        break
    basemeasurement = int(measurements[index]) + int(measurements[index+1]) + int(measurements[index+2])
    nextmeasurement = int(measurements[index+1]) + int(measurements[index+2]) + int(measurements[index+3])
    print (f'{basemeasurement} - {nextmeasurement}')
    if nextmeasurement > basemeasurement:
        slidercount += 1 

print(f'The total number of sliding drops is {slidercount}')