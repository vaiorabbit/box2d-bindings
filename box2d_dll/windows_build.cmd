::
:: For Windows + RubyInstaller2 with DevKit(MSYS2 gcc & make) + CMake users.
:: - Use this script after "ridk enable"d. See https://github.com/oneclick/rubyinstaller2/wiki/The-ridk-tool for details.
::
:: Usage
:: > ridk enable
:: > build_windows.bat  <- %PROGRAMFILES%\CMake\bin\cmake.exe will be used.
:: > build_windows.bat "D:\Program Files\CMake\bin\cmake.exe" <- You can give full path to 'cmake.exe'.

@echo off
setlocal enabledelayedexpansion

call split_inline.cmd

set CMAKE_EXE=%1
if "%CMAKE_EXE%"=="" (
    set CMAKE_EXE="%PROGRAMFILES%\CMake\bin\cmake"
)

pushd %~dp0
if not exist build (
    mkdir build
)
cd build
%CMAKE_EXE% -G "MSYS Makefiles" -D CMAKE_C_FLAGS="" -D CMAKE_BUILD_TYPE=Release -D CMAKE_OSX_ARCHITECTURES="x86_64" -D CMAKE_C_COMPILER=gcc -D BOX2D_SAMPLES=OFF -D BOX2D_VALIDATE=OFF -D BOX2D_UNIT_TESTS=OFF -D BUILD_SHARED_LIBS=ON ../box2d
cmake --build .
copy bin\libbox2d.dll ..\..\lib

popd
