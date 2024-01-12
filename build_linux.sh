#!/bin/sh

set -xe

FFLAGS="-std=f2018 -fno-range-check -Wall -Wextra -Wno-conversion"
LIBS="-I ./include/ -L ./lib/ -lraylib -lglfw -lpthread -ldl"
SRC="src/*.f90 app/main.f90"

mkdir -p build/
gfortran $FFLAGS -J build/ -o build/2048 $SRC $LIBS