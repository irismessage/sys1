#!/bin/bash
python2 ../assembler_v1d/Linux/simpleCPUv1d_as.py -i square -o code \
&& cp -vu code.dat ../modified_simpleCPU_v1d/
