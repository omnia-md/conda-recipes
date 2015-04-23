if [[ "$OSTYPE" == "linux-gnu" ]]; then
    export FC=gfortran
    export DEFAULT_HDF5_INCDIR=$INCLUDE_PATH
    export DEFAULT_HDF5_LIBDIR=$LIBRARY_PATH
    export CFLAGS="-I${INCLUDE_PATH} -fPIC"

    ./configure --with-hdf5 --with-zlib --prefix=$PREFIX
    for f in `find . -name Makefile`; do
	sed "s/LIBS =  -lm -lsz -lhdf5 -lz -lsz/LIBS = -lm -lhdf5 -lz/g" -i $f
    done
else
    ./configure --with-hdf5=$PREFIX/include,$PREFIX/lib --prefix=$PREFIX --with-zlib=$PREFIX/include,$PREFIX/lib
fi


make
make install
