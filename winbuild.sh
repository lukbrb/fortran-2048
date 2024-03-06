#!/bin/bash

# set -xe

RAYLIBDIR="raylib-5.0_win64_mingw-w64"
DLLPATH="/usr/lib/gcc/x86_64-w64-mingw32/12-win32"
FC="x86_64-w64-mingw32-gfortran"
MACHINE=$(uname -m)
STATIC=1
# OS=$(uname -s)
OS="win"
BUILDDIR="build-$OS-$MACHINE"
FORT2048DIR="$BUILDDIR/fortran-2048"
mkdir -p "$FORT2048DIR/ofiles"

SRC="src/iofiles.f90 src/raylib.f90 src/game.f90 src/ui.f90"
APP="app/main.f90"
FFLAGS="-std=f2018 -fno-range-check -Wall -Wextra -Wno-conversion"

INC="-I$RAYLIBDIR/include/"
LIB="-L$RAYLIBDIR/lib/"


for src_file in $SRC
do
    echo "Compiling $src_file..."
    filename=$(basename ${src_file%.*})
    $FC -c $src_file $FFLAGS $INC -J $FORT2048DIR -I$FORT2048DIR -o "$FORT2048DIR/ofiles/src_$filename.o"
    echo "$filename done"
done

ar -rs "$FORT2048DIR/libfortran-2048.a" $FORT2048DIR/ofiles/*.o

echo "Compiling $APP..."
filename=$(basename ${APP})
$FC -c $APP $FFLAGS $INC -J $FORT2048DIR -I$FORT2048DIR -o "$FORT2048DIR/app_$filename.o"

mkdir -p "$BUILDDIR/app"

if [[ "$STATIC" == 0 ]]; then
    echo "Compilation statique"
    STATIC_LIBS="-static-libgfortran -static-libgcc $DLLPATH/libquadmath.a"
    $FC $FFLAGS $INC $LIB $STATIC_LIBS "$FORT2048DIR/app_$filename.o" "$FORT2048DIR/libfortran-2048.a" -lraylib -lwinmm -lgdi32 -Wl,-rpath=lib -o $BUILDDIR/fort-2048

else
    echo "Compilation dynamique"
    $FC $FFLAGS $INC $LIB "$FORT2048DIR/app_$filename.o" "$FORT2048DIR/libfortran-2048.a" -lraylib -lwinmm -lgdi32 -lquadmath -Wl,-rpath=lib -o $BUILDDIR/fort-2048
    echo "Placement des dll dans le dossier app..."
    cp $DLLPATH/libgfortran-5.dll "$BUILDDIR/app"
    cp $DLLPATH/libquadmath-0.dll "$BUILDDIR/app"
    cp $DLLPATH/libgcc_s_seh-1.dll "$BUILDDIR/app"
fi

mv $BUILDDIR/fort-2048.exe "$BUILDDIR/app"




echo "=========================================================="
echo "Compilation terminée. L'executable se trouve dans le dossier $BUILDDIR/app."
