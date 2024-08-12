#!/bin/sh
export MACOSX_DEPLOYMENT_TARGET=14.0

mkdir -p build_x86_64
cd build_x86_64
cmake -D CMAKE_C_FLAGS="" -D CMAKE_BUILD_TYPE=Release -D CMAKE_OSX_ARCHITECTURES="x86_64" -D CMAKE_C_COMPILER=clang -D BOX2D_SAMPLES=OFF -D BOX2D_VALIDATE=OFF -D BOX2D_UNIT_TESTS=OFF -D BUILD_SHARED_LIBS=ON ../box2d
make
cp src/libbox2d.dylib ../../lib/libbox2d.x86_64.dylib

cd ..

mkdir -p build_arm64
cd build_arm64
cmake -D CMAKE_C_FLAGS="" -D CMAKE_BUILD_TYPE=Release -D CMAKE_OSX_ARCHITECTURES="arm64" -D CMAKE_C_COMPILER=clang -D BOX2D_SAMPLES=OFF -D BOX2D_VALIDATE=OFF -D BOX2D_UNIT_TESTS=OFF -D BUILD_SHARED_LIBS=ON ../box2d
make
cp src/libbox2d.dylib ../../lib/libbox2d.arm64.dylib
