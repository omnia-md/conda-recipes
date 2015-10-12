import os.path
from subprocess import check_output
libgfortran = check_output('gfortran -print-file-name=libgfortran.a').strip().decode('utf-8')
print(os.path.dirname(libgfortran))
