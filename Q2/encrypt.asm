# subroutine
# reverses the lower 8 bits in the ra register
# the reversed word is grown in the rb register
# the rc register counts a bit going up
# rd is also used for checking when loop ends
# todo cha cha slide joke
reverse:
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

maskl:
    .data 240
maskr:
    .data 15
left:
    .data 0
right:
    .data 0

# 16b pixel starts in ra
feistel:
    move rb ra

