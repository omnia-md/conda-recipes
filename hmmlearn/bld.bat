python setup.py build_ext --inplace
nosetests
python setup.py install
if errorlevel 1 exit 1
