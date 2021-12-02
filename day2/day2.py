#!/usr/bin/python3

# general

inputfile = 'day2/input.txt'


# part 1
horizontalpos = 0
depth = 0

input1 = open(inputfile, 'r')

for line in input1:
    command = line.split()
    # no match in python until 3.10, and I'm stuck on 3.9 on my debian - so "if" it is...
    if (command[0] == 'down'):
        depth += int(command[1])
    elif (command[0] == 'up'):
        depth -= int(command[1])
    elif (command[0] == 'forward'):
        horizontalpos += int(command[1])

print('Part 1 solution')
print(f'depth: {depth}, horizontal position: {horizontalpos}, answer: {depth * horizontalpos}')

# part 2
horizontalpos2 = 0
depth2 = 0
aim = 0

input2 = open(inputfile, 'r')
for line in input2:
    command = line.split()
    if (command[0] == 'down'):
        aim += int(command[1])
    elif (command[0] == 'up'):
        aim -= int(command[1])
    elif (command[0] == 'forward'):
        horizontalpos2 += int(command[1])
        depth2 += (aim * int(command[1]))

print('Part 2 solution')
print(f'depth: {depth2}, horizontal position: {horizontalpos2}, answer: {depth2 * horizontalpos2}')