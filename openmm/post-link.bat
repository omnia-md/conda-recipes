@echo off
echo ^
import os.path ^

import simtk ^

dir = os.path.dirname(simtk.__file__) ^

fn = os.path.join(dir, 'openmm', 'version.py') ^

f = open(fn, 'a') ^

f.write("\nopenmm_library_path = '%PREFIX%\\lib'") ^

f.close() ^

> _temp.py
%PREFIX%\python _temp.py
del _temp.py