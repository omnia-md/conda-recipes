"%PYTHON%" setup.py build --fcompiler=gnu95
"%PYTHON%" setup.py install
if errorlevel 1 exit 1
