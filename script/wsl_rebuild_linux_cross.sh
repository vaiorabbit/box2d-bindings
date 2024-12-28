# Usage : $ bash wsl_rebuild_linux_cross.sh foo /mnt/d/Users/foo/workbench/box2d-bindings/lib
bash tmp_rebuild_linux_cross.sh $1
cp /tmp/box2d-bindings/lib/*.aarch64.so $2
