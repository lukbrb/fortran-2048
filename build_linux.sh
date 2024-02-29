#!/bin/sh

set -xe

RAYLIBDIR="raylib"
FFLAGS="-std=f2018 -fno-range-check -Wall -Wextra -Wno-conversion"
# LIBS="-I ./include/ -L ./lib/ -lraylib -lglfw -lpthread -ldl"
#LIBS="-I ./include/ -L ./lib/ -lraylib -Wl,-rpath=./lib/ -lc -lgfortran -lm"
LIBS="-I$RAYLIBDIR/include -L$RAYLIBDIR/lib -lraylib -Wl,-rpath=lib/"
SRC="src/*.f90 app/main.f90"

mkdir -p build/
cp -r $RAYLIBDIR/lib build/
gfortran $FFLAGS -J build/ -o build/2048 $SRC $LIBS