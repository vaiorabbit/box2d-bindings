pushd .
cd ../box2d_dll
rm -r -f build
bash ./linux_cross_build.sh
popd
