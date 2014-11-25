from __future__ import print_function
from subprocess import check_output
from os import environ
from os.path import exists
shell = lambda cmd: check_output(cmd, shell=True)
print('Building conda packages on grid of python / numpy versions')
print('This will take a while... (15 minutes or more)')

def build(name):
    command = 'conda build --output %s' % name
    print(command)
    fn = shell(command)
    if not exists(fn):
        shell('conda build %s' % name)

build('fftw3f')

for CONDA_PY in ['27', '33', '34']:
    environ['CONDA_PY'] = CONDA_PY

    build('docopt')
    build('scripttest')
    build('openmm')
    build('msmbuilder')

    for CONDA_NPY in ['17', '18', '19']:
        environ['CONDA_NPY'] = CONDA_NPY
        build('fastcluster')
        build('mdtraj')
        del environ['CONDA_NPY']

build('ambermini')
build('pdbfixer')
build('openmmtools')
build('packmol')
build('gaff2xml')
build('repex')
build('yank')



