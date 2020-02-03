if [[ "$OSTYPE" == "darwin"* ]]; then
    ./configure --prefix=$PREFIX --enable-shared --disable-fortran --enable-static \
	--enable-threads --enable-sse2 --enable-single
else
    ./configure --prefix=$PREFIX --enable-shared --disable-fortran \
	--enable-threads --enable-sse2 --enable-single --enable-static
fi

make
make install
