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

writeadr:
    .data 0xfff
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
    .data 1484  # start + 14*24
staprite:
    .data 1163  # 1024 + 24*5 + 19
endprite:
    .data 1499  # start + 14*24

endp:
    .data 0
incr:
    .data 1


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
# ra - loads
# rb - pixel address
# rc - colour
# rd - increment
linesloop:
    store rc (rb)
    call alternate
# increment pixel address
# not I would implement the other add addressing mode,
# but I was highly depressed so missed most of this stuff
# and just need to pass the resit with 40% so
# pure assembly will be enough to make it run
    move ra rb
    addm ra incr
    move rb ra
# do while pixel is not endp
    subm ra endp
    jumpnz linesloop
    ret
# end of rows subroutine


# program entry point
start:
# rows
# top row
    load ra yellow
    move rc ra
    load ra staptop
    move rb ra
    load ra endptop
    store ra endp
    call linesloop
# bottom row
    load ra purple
    move rc ra
    load ra stapbot
    move rb ra
    load ra endpbot
    store ra endp
    call linesloop
# columns
    move ra 24
    store ra incr
# left column
    load ra purple
    move rc ra
    load ra stapleft
    move rb ra
    load ra endpleft
    store ra endp  
    call linesloop
# right column
    load ra yellow
    move rc ra
    load ra staprite
    move rb ra
    load ra endprite
    store ra endp
    call linesloop


# save image
load ra writeadr
move rb 0xff
store rb (ra)
exit:
    jump exit
