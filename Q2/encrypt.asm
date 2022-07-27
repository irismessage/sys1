jump start


# 2^8
revend:
    .data 256


# subroutine
# reverses the lower 8 bits in the ra register
# the reversed word is grown in the rb register
# the rc register counts a bit going up
# ra is copied to rd, and ra is used for looping
reverse:
    call roleight
    move rb 0
    move rc 1  # 2^i
    move rd ra  # original goes in rd
    takeitbacknowyall:
        rol rd
        move ra rd
        and ra 1  # branch if lowest bit is set
        jumpz onehopthistime
            xor rb rc  # set bit in rb
        onehopthistime:
        rol rc
        move ra rc
        subm ra revend  # ra used for checking loop end
        jumpnz takeitbacknowyall
    ret


# self explan-atory.
roleight:
    rol ra
    rol ra
    rol ra
    rol ra
    rol ra
    rol ra
    rol ra
    rol ra
    ret

lowmask:
    .data 256
pixel:
    .data 0
nr:
    .data 0


# example runthrough
# px 1000011001100100
# 3a = px[0:8]
# 3a 10000110         <- L
# 3b = px[8:16]
# 3b         01100100 <- R
# 3c = F(3b)
# 3c         00100110
# 3d = 3a xor 3c
# 3d         10100000 -> NR
# 3e = F(3d)
# 3e         00000101
# 3f = 3b xor 3e
# 3f 11000001         -> NL

# 16bit pixel starts in ra
# see notation in 3-feistel.png
feistel:
# example: 
    store ra pixel
    call reverse # ~ rb <- 3c ~ lower bits are reversed in rb
    load ra pixel
    call roleight
    and ra 255 # ~ ra <- 3a ~ upper bits are in lower ra
    xor ra rb  # ~ ra <- 3d ~ first xor
    store ra nr
    call reverse  # ~ ra <- 3e ~ second reverse
    move rb ra
    load ra pixel
    and ra 255
    xor ra rb # ~ 3f <- ra ~
    call roleight
    move rb ra
    load ra nr
    xor ra rb  # finally encrypted 16bit pixel is in ra
    ret


pixadr:
    .data 1024
# 24 * 24 = 576
# 1024 + 576 = 1600
endimg:
    .data 1600
writeadr:
    .data 0xfff


start:
    load ra pixadr
    move rb ra
    load ra (rb)  # load pixel from pixadr
    call feistel
    move rb ra  # encrypt pixel and move it to rb
    load ra pixadr
    store rb (ra)  # save pixel back to image
    add ra 1  # increment pixel address
    store ra pixadr  # save new pixel address
    subm ra endimg
    jumpnz start  # loop


# save image
load ra writeadr
move rb 0xff
store rb (ra)
exit:
    jump exit
