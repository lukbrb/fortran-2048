#!/bin/bash

set -xe

FFLAGS="-std=f2018 -fno-range-check -Wall -Wextra -Wno-conversion"
LIBS="-framework IOKit -framework Cocoa -framework OpenGL $(pkg-config --libs --cflags raylib)"
SRC="src/*.f90 app/main.f90"

mkdir -p build/
gfortran $FFLAGS -J build/ -o build/2048 $SRC $LIBS