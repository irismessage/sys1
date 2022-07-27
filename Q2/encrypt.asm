# subroutine
# reverses the lower 8 bits in the ra register
# the reversed word is grown in the rb register
# the rc register counts a bit going up
# rd is also used for checking when loop ends
# todo cha cha slide joke
reverse:
    call roleight
    move rc 1  # 2^i
    revloop:
        rol ra
        jumpc ycarry
        jump fcarry
        ycarry:
            xor rb rc
        fcarry:
        rol rc
        move rd rc
        sub rd 128
        jumpnz revloop
    move rb ra
    ret

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
maskl:
    .data 240  # 0b11110000
maskr:
    .data 15  # 0b00001111
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
    load rb nr
    xor ra rb  # finally encrypted 16bit pixel is in ra


# save image
load ra writeadr
move rb 0xff
store rb (ra)
exit:
    jump exit
