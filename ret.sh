#!/bin/bash
output="modified_simpleCPU_v1d/output.ppm"
stat --printf="File: %n\nModify: %y\n" "$output"
cp -vu "$output" .
