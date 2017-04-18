git apply --ignore-space-change --ignore-whitespace C:\\projects\\conda-recipes\\gpy\\win-fix.patch
"%PYTHON%" setup.py install
if errorlevel 1 exit 1
