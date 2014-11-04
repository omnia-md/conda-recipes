if [[ "$OSTYPE" == "darwin"* ]]; then
    ./configure --prefix=$PREFIX --enable-shared --disable-fortran --disable-static \
	--enable-threads --enable-sse2 --enable-single
else
    ./configure --prefix=$PREFIX --enable-shared --disable-fortran \
	--enable-threads --enable-sse2 --enable-single
fi

make
make install
