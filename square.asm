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
    jump rows
alternate:
    # colour alternator subroutine
    # checks 0 or 1 from rb
    # puts correct colour in rc
    and rb 1
    jumpnz purple
    yellow:
        # rb is 0
        move rb 1
        move rc 65523
        ret
    purple:
        # rb is 1
        move rb 0
        move rc 52031
        ret

rows:
    # pixel memory pointer
    # 1024 + 24*4 + 4
    move ra 1124
    # colour alternator counter
    move rb 1
    move rc 65523
rowsloop:
    store rc (ra)
    call alternate
    xor ra 1141
    jumpnz rowsloop

write:
    move ra 0xff
    store ra 0xfff
exit:
    jump exit
