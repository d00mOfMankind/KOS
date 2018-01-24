#Errors
#check for . terminators
#check for matching }'s

#Warnings
#Unnecessary whitespace
#Function call without perentheses
#FIle not saved as .ks

import sys
import os

def isBlank(line):
	for char in line:
		if not char == "\n" and not char == " " and not char == "	":
			return False

	return True

def getLastValidCharacter(line):
	if "//" in line:
		for x in range(1, len(line)):
			pass
	else:
		return line[-2:-1]


errors = 0 #initilise number of errors
warnings = 0

if not len(sys.argv) == 2: #check if correct number of arguments given
	print("Only enter one argument, the filename/path.")
	sys.exit()

if not os.path.isfile(sys.argv[1]): #check if file exists
	print("File does not exist.")
	sys.exit()

if not str(sys.argv[1])[-3:] == ".ks": #if file extension is not .ks
	print("WARNING: File is not saved with extension .ks")
	warnings=+1


file = open(sys.argv[1], 'r')

lineNumber = 1
for line in file:
	if not getLastValidCharacter(line) == '.' and not isBlank(line):
		print(str(lineNumber) + " ERROR: Line does not have terminator")
		print(line[-2:-1])
		errors+=1



	lineNumber+=1

print(errors)
print(warnings)
