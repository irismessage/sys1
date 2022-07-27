start:
# 127 / 3 = 42.3333 ≈ 40
# 40 = 0b00101000
    move RA 0x7F      # set dummy pixel values
    call divide       # divide 0x7F/3=0x2A
    store RA 0xFFF    # signal subroutine finished

# 15 / 3 = 5
# 5 = 0b00000101
    move RA 0x0F      # set dummy pixel values
    call divide       # divide 0x0F/3=0x05
    store RA 0xFFF    # signal subroutine finished

#    move RA XXX       # random value XXX assigned
#    call divide       # during testing
#    store RA 0xFFF    # signal subroutine finished

trap:
    jumpu trap        # end


# divides by three (3)
# rounds down
# argument: ra
# return: ra
divide:
    move rb 0
    move rd 0
    loop:
        add rb 1
        sub ra 3
# return if ra is between 0 and 2 inclusive
            jumpz end
            move rc ra
            sub rc 1
            jumpz end
            sub rc 1
            jumpz end
        jump loop
    end:
        move ra rb
    ret
