from __future__ import print_function
from subprocess import check_output
from os import environ
from os.path import exists
shell = lambda cmd: check_output(cmd, shell=True)
print('Building python2.7 and python3.3 conda packages')
print('This will take a while... (15 minutes or more)')

def build(name):
    fn = shell('conda build --output %s' % name)
    if not os.path.exists(fn):
        shell('conda build %s' % name)

build('fftw3f')

for CONDA_PY in ['27', '33']:
    environ['CONDA_PY'] = CONDA_PY

    build('scripttest')
    build('openmm')
    build('msmbuilder')

    for CONDA_NPY = ['17', '18']:
        environ['CONDA_NPY'] = CONDA_NPY
        build('fastcluster')
        build('mdtraj')
        del environ['CONDA_NPY']

build('ambermini')
build('pdbfixer')



