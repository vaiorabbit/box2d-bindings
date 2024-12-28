cd /tmp
rm -rf /tmp/box2d-bindings
git clone https://github.com/vaiorabbit/box2d-bindings.git --branch update --depth=1 --recurse-submodules --shallow-submodules
cd box2d-bindings/script
bash ./rebuild_libs_linux_cross.sh
cd ..
git config user.name $1
git config user.email $1
git add lib/*
git commit -a -m "commit by $1"
# git push --force-with-lease -u origin update

