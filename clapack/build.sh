mkdir build
cd build
CMAKE_FLAGS=" -DCMAKE_INSTALL_PREFIX=$PREFIX"
CMAKE_FLAGS+=" -DCMAKE_BUILD_TYPE=Release"
CMAKE_FLAGS+=" -Wno-dev"
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    echo "hello";
elif [[ "$OSTYPE" == "darwin"* ]]; then
    CMAKE_FLAGS+=" -DCMAKE_OSX_DEPLOYMENT_TARGET=''"
fi

cmake $CMAKE_FLAGS ..
make -j4 install
