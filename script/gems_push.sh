#!/bin/sh
pushd .
cd ..
for i in `ls box2d-bindings-*.gem`; do
    echo gem push $i
done
popd
