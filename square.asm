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


# rows subroutine
# called once for top and once for bottom
rowr:
# ra - loads
# rb - pixel address
# rc - colour
    load ra stap
    move rb ra
# load start colour
    load ra startcolour
    move rc ra
rowsloop:
    store rc (rb)
    call alternate
# increment pixel address
    add rb 1
# do while pixel is not 1141
    move ra rb
    subm ra endp
    jumpnz rowsloop
    ret
# end of rows subroutine


# program entry point
start:
# top row
    load ra staptop
    store ra stap
    load ra endptop
    store ra endp
    load ra yellow
    store ra startcolour
    call rowr
# bottom row
    load ra stapbot
    store ra stap
    load ra endpbot
    store ra endp
    load ra purple
    store ra startcolour
    call rowr
    

jump write

# save image
writeadr:
    .data 0xfff
write:
    load ra writeadr
    move rb 0xff
    store rb (ra)
