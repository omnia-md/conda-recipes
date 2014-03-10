if [[ "$OSTYPE" == "darwin"* ]]; then
    # without manually specifying arch i386 and x86_64, we don't get a 
    # universal binary on OSX
    ./configure --prefix=$PREFIX --enable-shared --disable-fortran \
	--enable-threads --enable-sse2 --enable-single \
	CC="gcc -arch i386 -arch x86_64" CXX="g++ -arch i386 -arch x86_64" \
	CPP="gcc -E" CXXCPP="g++ -E"
else
    ./configure --prefix=$PREFIX --enable-shared --disable-fortran \
	--enable-threads --enable-sse2 --enable-single
fi

make
make install
