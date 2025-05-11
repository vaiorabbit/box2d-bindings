#!/bin/sh

bash ./split_inline.sh

mkdir -p build
cd build
cmake -D CMAKE_C_FLAGS="" -D CMAKE_BUILD_TYPE=Release -D CMAKE_C_COMPILER=clang -Dbox2d_EXPORTS=1 -D BOX2D_SAMPLES=OFF -D BOX2D_VALIDATE=OFF -D BOX2D_UNIT_TESTS=OFF -D BUILD_SHARED_LIBS=ON ../box2d
cmake --build .
export ARCH=`uname -m`
cp bin/libbox2d.so ../../lib/libbox2d.${ARCH}.so
