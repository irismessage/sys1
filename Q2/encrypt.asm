jump start


revend:
    .data 128


# subroutine
# reverses the lower 8 bits in the ra register
# the reversed word is grown in the rb register
# the rc register counts a bit going up
# rd is also used for checking when loop ends
# todo cha cha slide joke
reverse:
    call roleight
    move rb 0
    move rc 1  # 2^i
    move rd ra  # original goes in rd
    revloop:
        rol rd
        move ra rd
        and ra 1  # branch if lowest bit is set
        jumpz fcarry
            xor rb rc  # set bit in rb
        fcarry:
        rol rc
        move ra rc
        subm ra revend  # ra used for checking loop end
        jumpnz revloop
    move rb ra
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

writeadr:
    .data 0xfff
pixel:
    .data 0
nr:
    .data 0

# 16bit pixel starts in ra
# see notation in 3-feistel.png
feistel:
    store ra pixel
    call reverse
    move rb ra  # ~ rb <- 3c ~ lower bits are reversed in ra
    load ra pixel
    call roleight  # ~ ra <- 3a ~ upper bits are in ra
    xor ra rb  # ~ ra <- 3d ~ first xor
    store ra nr
    call reverse  # ~ ra <- 3e ~ second reverse
    move rb ra
    load ra pixel
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
