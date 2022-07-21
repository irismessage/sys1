#!/bin/bash
python2 ./blr/simpleCPUv1d_as.py -i code -o code
cp -vut modified_simpleCPU_v1d/ code.dat image.ppm
