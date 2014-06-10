import os
for conda_py in ['27', '33']:
    for npy in ['17', '18']:
        os.environ["CONDA_PY"] = conda_py
        os.environ["CONDA_NPY"] = npy
        os.system('conda build msmbuilder')
