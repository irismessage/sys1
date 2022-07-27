start:
# 127 / 3 = 42.3333 ≈ 40
    move RA 0x7F      # set dummy pixel values
    call divide       # divide 0x7F/3=0x2A
    store RA 0xFFF    # signal subroutine finished

# 15 / 3 = 5
    move RA 0x0F      # set dummy pixel values
    call divide       # divide 0x0F/3=0x05
    store RA 0xFFF    # signal subroutine finished

#   move RA XXX       # random value XXX assigned
    call divide       # during testing
    store RA 0xFFF    # signal subroutine finished

trap:
    jumpu trap        # end


# divides by three (3)
# rounds down
# argument: ra
# return: ra
divide:
    move rb 0
    loop:
        add rb 1
        sub ra 3
        jumpc end
        jump loop
    end:
        sub rb 1
        move ra rb
    ret
