# notes


# COLOURS
# purple
# cc66ff
# 11001100 01100110 11111111
# 11001    011001   11111
# 1100101100111111
# 52031
# yellow
# ffff99
# 11111111 11111111 10011001
# 11111    111111   10011
# 1111111111110011
# 65523

# SQUARE
# square is 16x16
# (04,04) yellow      (20,04) purple
#                ⌜  ⌝
#                ⌞  ⌟
# (04,20) purple      (20,20) yellow

# MEMORY
# image data starts at 1024
# image is 24x24
# each pixel is 16 bits - one address

# regs and mems are 16 bit
# ops are 8 bit???
# use .data and load to use >8bit values

# PYTHON
# bin() hex() 0x 0b


jump start


# colours
yellow:
    .data 65523
purple:
    .data 52031

# pixel addresses
# start pixel, top
staptop:
    .data 1124  # 1024 + 24*4 + 4
# end pixel, top
endptop:
    .data 1140  # start + 16
# start pixel, bottom
stapbot:
    .data 1484  # 1024 + 24*19 + 4
# end pixel, bottom
endpbot:
    .data 1500  # start + 16
# 15 * 24 = 360
stapleft:
    .data 1148  # 1024 + 24*5 + 4
endpleft:
    .data 1508  # start + 15*24
staprite:
    .data 1164  # 1024 + 24*5 + 20
endprite:
    .data 1524  # start + 15*24

stap:
    .data 0
endp:
    .data 0
startcolour:
    .data 0


# colour alternator subroutine
alternate:
# swaps colour in rc
# uses ra to load
    move ra rc
    subm ra yellow
    jumpz loadpurple
    loadyellow:
# rb is 0
        load ra yellow
        move rc ra  # always keep ra free for loading
        ret
    loadpurple:
# rb is 1
        load ra purple
        move rc ra
        ret
# end of alternate subroutine


# lines subroutine
# called once each for top, bottom, left, and right
liner:
# ra - loads
# rb - pixel address
# rc - colour
# rd - increment
    load ra stap
    move rb ra
# load start colour
    load ra startcolour
    move rc ra
linesloop:
    store rc (rb)
    call alternate
# increment pixel address
    add rb rd
# do while pixel is not 1141
    move ra rb
    subm ra endp
    jumpnz linesloop
    ret
# end of rows subroutine


# program entry point
start:
# rows
    move rd 1
# top row
    load ra staptop
    store ra stap
    load ra endptop
    store ra endp
    load ra yellow
    store ra startcolour
    call liner
# bottom row
    load ra stapbot
    store ra stap
    load ra endpbot
    store ra endp
    load ra purple
    store ra startcolour
    call liner
# columns
    move rd 24
# left column
    load ra stapleft
    store ra stap
    load ra endpleft
    store ra endpbot
# start colour of purple same as bottom row
    call liner
# right column
    load ra staprite
    store ra stap
    load ra endprite
    store ra endprite
    load ra yellow
    store ra startcolour
    call liner
    

jump write

# save image
writeadr:
    .data 0xfff
write:
    load ra writeadr
    move rb 0xff
    store rb (ra)
