echo 'Building python2.7 and python3.3 conda packages'
echo 'This will take a while... (15 minutes or more)'

for CONDA_PY in 27 33; do
    export CONDA_PY=$CONDA_PY
    for CONDA_NPY in 17 18; do
        export CONDA_NPY=$CONDA_NPY
        conda build fastcluster
        conda build mdtraj
    done
done

exit

for CONDA_NPY in 17 18; do
  export CONDA_PY=27
  export CONDA_NPY=$CONDA_NPY
  conda build msmbuilder
done


conda build fftw3f
for CONDA_PY in 27 33; do
    export CONDA_PY=$CONDA_PY
    conda build scripttest
    conda build openmm
    conda build mdtraj
done

conda build ambermini
conda build pdbfixer



