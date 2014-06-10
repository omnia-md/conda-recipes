echo 'Building python2.7 and python3.3 conda packages'
echo 'This will take a while... (15 minutes or more)'

function build {
    output=`conda build --output $1`
    if [[ ! -f $output ]]; then
	conda build $1
    fi
}

for CONDA_PY in 27 33; do
    export CONDA_PY=$CONDA_PY
    for CONDA_NPY in 17 18; do
        export CONDA_NPY=$CONDA_NPY
        build fastcluster
        build mdtraj
    done
done

for CONDA_NPY in 17 18; do
  export CONDA_PY=27
  export CONDA_NPY=$CONDA_NPY
  build msmbuilder
done


conda build fftw3f
for CONDA_PY in 27 33; do
    export CONDA_PY=$CONDA_PY
    build scripttest
    build openmm
    build mdtraj
done

build ambermini
build pdbfixer



