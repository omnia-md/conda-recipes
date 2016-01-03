if [[ "$OSTYPE" == "darwin"* ]]; then
    export DYLD_LIBRARY_PATH=$PREFIX/lib
fi

LDFLAGS="-L$PREFIX/lib" ./configure --prefix=$PREFIX \
    --with-blas=openblas --with-lapack=openblas
make
make install
