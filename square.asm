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
# each pixel is 16 bits

# PYTHON
# bin() hex() 0x 0b

start:
# load colours
    yellow:
        .data 65523
    purple:
        .data 52031
    jump rows
alternate:
# colour alternator subroutine
# swaps colour in rc
# uses ra to load
    sub rc yellow
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

rows:
# ra - loads
# rb - pixel address
# rc - colour
# pixel memory pointer
# 1024 + 24*4 + 4
    pixel:
        .data 1124
    load ra pixel
    move rb ra
# colour alternator counter
    load ra yellow
    move rc ra  # start at yellow
rowsloop:
    store rc (rb)
    call alternate
# increment pixel address
    add rb 1
# do while pixel is not 1141
    move ra rb
    subm ra pixel
    jumpnz rowsloop

write:
    .data 0xfff
    load ra write
    move rb 0xff
    store rb (ra)
