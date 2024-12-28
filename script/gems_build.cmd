@echo off
pushd %CD%
cd ..
call gem.cmd build box2d-bindings.gemspec
call gem.cmd build box2d-bindings.gemspec --platform arm64-darwin
call gem.cmd build box2d-bindings.gemspec --platform x86_64-darwin
call gem.cmd build box2d-bindings.gemspec --platform aarch64-linux
call gem.cmd build box2d-bindings.gemspec --platform x86_64-linux
call gem.cmd build box2d-bindings.gemspec --platform x64-mingw
popd
