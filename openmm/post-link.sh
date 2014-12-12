if [[ "$OSTYPE" == "darwin"* ]]; then
    # http://answers.opencv.org/question/4134/
    # make the lib/libOpenMM*.dylib and lib/plugins/libOpenMM*.dylib
    # point to each other using absolute paths
    find "${PREFIX}/lib" -type f -name "libOpenMM*.dylib" -print0 | while IFS="" read -r -d "" dylibpath; do
        otool -L $dylibpath | grep libOpenMM | tr -d ':' | while read -a libs; do
            if [ "${file}" != "${libs[0]}" ]; then
                install_name_tool -change ${libs[0]} "${PREFIX}/lib/"`basename ${libs[0]}` $dylibpath
            fi
       done
    done

    # make site-packages/simtk/openmm/_openmm.so point to the correct
    # libraries in lib/
    find $PREFIX/lib/python*/site-packages/simtk/openmm -type f -name "_openmm.so" -print0 | while IFS="" read -r -d "" dylibpath; do
        otool -L $dylibpath | grep libOpenMM | tr -d ':' | while read -a libs; do
            if [ "${file}" != "${libs[0]}" ]; then
                install_name_tool -change ${libs[0]} "${PREFIX}/lib/"`basename ${libs[0]}` $dylibpath
            fi
       done
    done


fi

# For anaconda installs, the OpenMM examples should probably go in ~/anaconda/share/examples/openmm/
mkdir $PREFIX/share/openmm/
mkdir $PREFIX/share/openmm/examples
mv $PREFIX/share/examples $PREFIX/share/openmm/examples
