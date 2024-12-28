#!/bin/sh
pushd .
cd ..
gem build box2d-bindings.gemspec
gem build box2d-bindings.gemspec --platform arm64-darwin
gem build box2d-bindings.gemspec --platform x86_64-darwin
gem build box2d-bindings.gemspec --platform aarch64-linux
gem build box2d-bindings.gemspec --platform x86_64-linux
gem build box2d-bindings.gemspec --platform x64-mingw
popd
