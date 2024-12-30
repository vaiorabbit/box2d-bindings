#!/bin/sh
mkdir -p build
cd build
cmake -D CMAKE_C_FLAGS=-isystem\ /usr/aarch64-linux-gnu/include -D CMAKE_BUILD_TYPE=Release -D CMAKE_C_COMPILER_TARGET=aarch64-linux-gnu -D CMAKE_SYSTEM_PROCESSOR=ARM -Dbox2d_EXPORTS=1 -D BOX2D_SAMPLES=OFF -D BOX2D_VALIDATE=OFF -D BOX2D_UNIT_TESTS=OFF -D BUILD_SHARED_LIBS=ON -D CMAKE_C_COMPILER=clang ../box2d
cmake --build .
export ARCH=aarch64
cp src/libbox2d.so ../../lib/libbox2d.${ARCH}.so

