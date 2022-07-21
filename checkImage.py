#!/usr/bin/python
import getopt
import sys
import re

if len(sys.argv) == 1:
  print "Usage: checkImage.py -i <input_file> -o <output_file>"
  exit()

version = '1.0'
source_filename      = 'image.ppm'
destination_filename = 'output.ppm'

address = 0
byte_count = 0

try:
  options, remainder = getopt.getopt(sys.argv[1:], 'i:o:', [ 'input=', 
                                                             'output=' ])
except getopt.GetoptError as m:
  print "Error: ", m
  exit()

for opt, arg in options:
  if opt in ('-o', '--output'):
    if ".pbm" in arg:
      destination_pbm_filename = arg
    else:
      destination_ppm_filename    = arg + ".ppm"

  elif opt in ('-i', '--input'):
    if ".ppm" in arg:
      source_filename = arg
    else:
      source_filename = arg + ".ppm"

#print source_filename, destination_filename

try:
  source_file = open(source_filename, "r")
except IOError: 
  print "Error: Input file does not exist."
  exit() 

try:
  destination_file    = open(destination_filename, "w")

except IOError: 
  print "Error: Could not open output file"
  exit() 
  
line = source_file.readline()
if "P3" in line:
  pass
else:
  print "Error: Not PPM image - missing id"
  exit()  

line = source_file.readline()
if "#" in line:
  pass
else:
  print "Error: Not PPM image - missing description "
  exit() 

line = source_file.readline()
w,h = line.split(" ")

#print w, h

image_R = [[0 for x in range(int(w))] for y in range(int(h))] 
image_G = [[0 for x in range(int(w))] for y in range(int(h))] 
image_B = [[0 for x in range(int(w))] for y in range(int(h))] 

image_RED   = [0 for x in range(int(w)*int(h))]
image_GREEN = [0 for x in range(int(w)*int(h))]
image_BLUE  = [0 for x in range(int(w)*int(h))]

line = source_file.readline()
maximum = line

pixel  = 0
column = 0
row    = 0

while True:
  line = source_file.readline()
  if line == '':
    break 

  if column < int(w):
    if pixel == 0:
      image_R[row][column] = int(line)
      pixel += 1
    elif pixel == 1:
      image_G[row][column] = int(line)
      pixel += 1
    else:
      image_B[row][column] = int(line)
      pixel = 0

      column += 1
      if column == int(w):
        column = 0
        row += 1

pixel  = 0
for y in range(int(h)):
  for x in range(int(w)):
    image_RED[pixel]   = image_R[y][x] >>3
    image_GREEN[pixel] = image_G[y][x] >>2 
    image_BLUE[pixel]  = image_B[y][x] >>3
    pixel +=1

destination_file.write( "P3" + "\n" )
destination_file.write( "# new image"  + "\n" )
destination_file.write( str(int(w)) + " " + str(int(h)) + "\n" )
destination_file.write( "255"  + "\n" )

pixel = 0
for y in range(int(h)):
  for x in range(int(w)):
    destination_file.write( "0 0 " + str(image_BLUE[pixel]<<3) + "\n" )
    pixel +=1

source_file.close() 
destination_file.close()




