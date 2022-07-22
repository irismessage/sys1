# notes


# COLOURS
# purple
# cc66ff
# 11001100 01100110 11111111
# 11001    011001   11111
# 11001011 00111111
# 203      63
# yellow
# ffff99
# 11111111 11111111 10011001
# 11111    111111   10011
# 11111111 11110011
# 255      243

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
# swaps out the 16bit colour split between rb and rc
    sub rb 255
    jumpz purple
    yellow:
        move rb 255
        move rc 243
        ret
    purple:
        move rb 203
        move rc 63
        ret

rows:
# pixel memory pointer
# 1024 + 24*4 + 4
    move ra 1124
# start on yellow
    move rb 255
    move rc 253
rowsloop:
# write pixel
    store rb (ra)
    add ra 1
    store rc (ra)
    add ra 1
    call alternate  # switch colour
# do while ra is not 1057
# 1056 = 1024 + 16 * 2
    move rd ra
    sub rd 1057
    jumpnz rowsloop

write:
    move ra 0xff
    store ra 0xfff
exit:
    jump exit
