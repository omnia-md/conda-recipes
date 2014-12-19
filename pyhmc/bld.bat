"%PYTHON%" setup.py clean
"%PYTHON%" setup.py install
if errorlevel 1 exit 1
