:: "%PYTHON%" setup.py build --compiler=mingw32 install
"%PYTHON%" setup.py install
if errorlevel 1 exit 1
