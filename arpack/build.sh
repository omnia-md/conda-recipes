if [[ "$OSTYPE" == "darwin"* ]]; then
    export DYLD_LIBRARY_PATH=$PREFIX/lib
    ./configure --prefix=$PREFIX
else
    LDFLAGS="-L$PREFIX/lib" ./configure --prefix=$PREFIX \
        --with-blas=openblas --with-lapack=openblas
fi
make
make install
