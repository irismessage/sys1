#!/usr/bin/python
import getopt
import sys
import re

def bit_reverse(i, n):
    return int(format(i, '0%db' % n)[::-1], 2)

if len(sys.argv) == 1:
  print "Usage: threshold.py -i <input_file> -o <output_file>"
  exit()

version = '1.0'
source_filename = 'output.ppm'
destination_filename = 'new.ppm'

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
      destination_filename = arg
    else:
      destination_filename = arg + ".pbm"
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
  destination_file = open(destination_filename, "w")
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

print w, h

image_R = [[0 for x in range(int(w))] for y in range(int(h))] 
image_G = [[0 for x in range(int(w))] for y in range(int(h))] 
image_B = [[0 for x in range(int(w))] for y in range(int(h))] 

new_R = [[0 for x in range(int(w))] for y in range(int(h))] 
new_G = [[0 for x in range(int(w))] for y in range(int(h))] 
new_B = [[0 for x in range(int(w))] for y in range(int(h))] 

line = source_file.readline()
maximum = line

column = 0
row    = 0
while True:
  line = source_file.readline()
  if line == '':
    break 

  if column < int(w):
    tmp = line.split()
    image_R[row][column] = int(tmp[0])
    image_G[row][column] = int(tmp[1])
    image_B[row][column] = int(tmp[2])

  column += 1
  if column == int(w):
    column = 0
    row += 1

for y in range(int(h)):
  for x in range(int(w)):
    RGB = ((image_R[y][x] & 0xF8) << 8) + ((image_G[y][x] & 0xFC) << 3) + (image_B[y][x] >> 3)

    LH = (RGB & 0xFF00) // 256
    RH = RGB & 0xFF
    RRH = bit_reverse((RGB & 0xFF), 8)
    TMP = (RRH ^ LH) & 0xFF
    RTMP = bit_reverse(TMP, 8)
    NLH = ((RTMP ^ RH) * 256)
    NRGB = NLH | TMP

    outputString = "Encrypted RGB = " + hex(RGB) + " Decrypted RGB = " + hex(NRGB)
    print outputString

    new_R[y][x] = (NRGB >> 8) & 0xF8
    new_G[y][x] = (NRGB >> 3) & 0xFC   
    new_B[y][x] = (NRGB << 3) & 0xF8   
  
 
destination_file.write( "P3" + "\n" )
destination_file.write( "# new image"  + "\n" )
destination_file.write( str(int(w)) + " " + str(int(h)) + "\n" )
destination_file.write( "255 \n" )

for y in range(int(h)):
  for x in range(int(w)):
    destination_file.write( str(new_R[y][x]) + " " + str(new_G[y][x]) + " " + str(new_B[y][x]) + "\n" )

source_file.close() 
destination_file.close()



