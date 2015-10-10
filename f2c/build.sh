mkdir -p $PREFIX/bin
mkdir -p $PREFIX/include
mkdir -p $PREFIX/lib

curl http://www.netlib.org/f2c/src/makefile.u -o src/Makefile
(cd src && make -j$CPU_COUNT)

cp src/f2c $PREFIX/bin
cp f2c.h   $PREFIX/include


curl http://archive.ubuntu.com/ubuntu/pool/universe/libf/libf2c2/libf2c2_20090411.orig.tar.gz -o libf2c2_20090411.orig.tar.gz
tar -xzvf libf2c2_20090411.orig.tar.gz
cd libf2c2-20090411.orig

sed 's/CFLAGS = -O/CFLAGS = -O3 -fPIC/' makefile.u > Makefile
make -j$CPU_COUNT

cp libf2c.a $PREFIX/lib/libf2c.a
