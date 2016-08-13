"%PYTHON%" setup.py bdist_wheel --universal
"%PYTHON%" -m wheel install dist/*

if errorlevel 1 exit 1

