BUILD_DIR=/opt/build

mkdir -p "$BUILD_DIR/AppDir/usr"

cd $BUILD_DIR

# Obtain and compile libevent

git clone https://github.com/libevent/libevent --depth 1 \
    -b release-2.1.12-stable
cd libevent
sh autogen.sh
./configure \
    --prefix="$BUILD_DIR/AppDir/usr" \
    --enable-shared
make -j4
make install
cd ../