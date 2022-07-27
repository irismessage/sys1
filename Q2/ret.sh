#!/bin/bash
set -e
../ret.sh
python2 "decrypt.py" -i output
xdg-open "new.ppm" 2> /dev/null
