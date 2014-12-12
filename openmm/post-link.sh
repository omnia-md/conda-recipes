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
# Now we handle this manually, in the future we should probably add an extra flag in 
# CMAKE to make this cleaner.
mkdir -p $PREFIX/share/openmm/examples

mv -t $PREFIX/share/openmm/examples $PREFIX/examples/simulateAmber.py $PREFIX/examples/simulatePdb.py $PREFIX/examples/simulateGromacs.py 
mv -t $PREFIX/share/openmm/examples $PREFIX/examples/benchmark.py $PREFIX/examples/argon-chemical-potential.py 
mv -t $PREFIX/share/openmm/examples $PREFIX/examples/input.inpcrd $PREFIX/examples/input.prmtop $PREFIX/examples/input.pdb $PREFIX/examples/input.gro $PREFIX/examples/input.top 
mv -t $PREFIX/share/openmm/examples $PREFIX/examples/5dfr_minimized.pdb $PREFIX/examples/5dfr_solv-cube_equil.pdb
mv -t $PREFIX/share/openmm/examples $PREFIX/examples/README.txt $PREFIX/examples/Makefile $PREFIX/examples/NMakefile $PREFIX/examples/MakefileNotes.txt $PREFIX/examples/Empty.cpp

mv -t $PREFIX/share/openmm/examples $PREFIX/examples/VisualStudio
