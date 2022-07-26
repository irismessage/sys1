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
# checks 0 or 1 from rb
# puts correct colour in rc
    and rb 1
    jumpnz loadpurple
    loadyellow:
# rb is 0
        move rb 1
        load rc yellow
        ret
    loadpurple:
# rb is 1
        move rb 0
        load rc purple
        ret

rows:
# pixel memory pointer
# 1024 + 24*4 + 4
    pixel:
        .data 1124
    load ra pixel
# colour alternator counter
    move rb 1
    load rc yellow  # start at yellow
rowsloop:
    store rc (ra)
    call alternate
# increment ra
    add ra 1
# do while ra is not 1141
    move rd ra
    sub rd 
    jumpnz rowsloop

write:
    .data 0xfff
    move ra 0xff
    store ra write
exit:
    jump exit
