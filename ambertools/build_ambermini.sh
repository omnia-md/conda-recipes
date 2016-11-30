#!/bin/sh

# extract from ${AMBERHOME}/AmberTools/src/Makefile
echo ${AMBERHOME}
(cd ${AMBERHOME}/AmberTools/src/byacc && make install )
(cd ${AMBERHOME}/AmberTools/src/cifparse && make install )
(cd ${AMBERHOME}/AmberTools/src/xblas && make -j 1 lib-amb && mv libxblas-amb.a ${AMBERHOME}/lib/)
(cd ${AMBERHOME}/AmberTools/src/leap && make install)
(cd ${AMBERHOME}/AmberTools/src/sqm && make install)
(cd ${AMBERHOME}/AmberTools/src/antechamber && make install)
(cd ${AMBERHOME}/AmberTools/src/reduce && make install)
(cd ${AMBERHOME}/AmberTools/src/paramfit && make install)
