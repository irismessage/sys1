#!/bin/bash
dir="$HOME/src/SYS1/"
assembler="$dir/assembler_v1d/Linux/simpleCPUv1d_as.py"
pattern="*.asm"
files=( $pattern )
python2 "$assembler" -i "${files[0]}" -o "code" \
&& cp -vu code.dat "$dir/modified_simpleCPU_v1d/"
