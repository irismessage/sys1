start:
  move RA 0x7F      # set dummy pixel values
  call divide       # divide 0x7F/3=0x2A
  store RA 0xFFF    # signal subroutine finished

  move RA 0x0F      # set dummy pixel values
  call divide       # divide 0x0F/3=0x05
  store RA 0xFFF    # signal subroutine finished

  move RA XXX       # random value XXX assigned
  call divide       # during testing
  store RA 0xFFF    # signal subroutine finished

trap:
  jumpu trap        # end

divide:
  ...               # add your code here

  ret

data:
  ...               # add your data/variables here


