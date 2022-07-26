#!/bin/bash
output="${HOME}/src/SYS1/modified_simpleCPU_v1d/output.ppm"
stat --printf="File: %n\nModify: %y\n" "$output"
cp -vu "$output" .
xdg-open "$output" 2> /dev/null
