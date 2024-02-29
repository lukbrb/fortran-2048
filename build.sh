#!/bin/bash

# set -xe

RAYLIBDIR="raylib-source"
FFLAGS="-std=f2018 -fno-range-check -Wall -Wextra -Wno-conversion"
SRC="src/*.f90 app/main.f90"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "[INFO] Détection d'une machine Linux"
    echo "[INFO] Compilation en cours..."
    LIBS="-I$RAYLIBDIR/include -L$RAYLIBDIR/lib -lraylib -Wl,-rpath=lib/"
    mkdir -p build/
    cp -r $RAYLIBDIR/lib build/
    gfortran $FFLAGS -J build/ -o build/2048 $SRC $LIBS

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "[INFO] Détection d'une machine sous MacOS"
    echo "[INFO] Compilation en cours..."
    LIBS="-I$RAYLIBDIR/include -L$RAYLIBDIR/lib -lraylib -Wl,-rpath=lib/"
    # LIBS="-framework IOKit -framework Cocoa -framework OpenGL $(pkg-config --libs --cflags raylib)"
    mkdir -p build/
    cp -r $RAYLIBDIR/lib build/
    gfortran $FFLAGS -J build/ -o build/2048 $SRC $LIBS

elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
        echo "[INFO] La compilation sous Windows n'est pas encore prise en compte."
elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
        echo "[INFO] La compilation sous Windows n'est pas encore prise en compte."
        # ...
else
        echo "OS Inconnu"
fi

# LIBS="-I ./include/ -L ./lib/ -lraylib -lglfw -lpthread -ldl"
#LIBS="-I ./include/ -L ./lib/ -lraylib -Wl,-rpath=./lib/ -lc -lgfortran -lm"
