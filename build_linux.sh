#!/bin/sh

set -xe

FFLAGS="-std=f2003 -fno-range-check -Wall -Wextra -Wno-conversion"
LIBS="-I ./include/ -L ./lib/ -lraylib -lglfw3 -lpthread -ldl"
SRC="src/*.f90 app/main.f90"

mkdir -p build/
gfortran $FFLAGS -J build/ -o build/2048 $SRC $LIBS