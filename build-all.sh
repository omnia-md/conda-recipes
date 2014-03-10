echo 'Building python2.7 and python3.3 conda packages'
echo 'This will take a while... (15 minutes or more)'

conda build fftw3f
for CONDA_PY in 27 33; do
    export CONDA_PY=$CONDA_PY
    conda build scripttest
    conda build openmm
    conda build mdtraj
done
