bash .\configure %PREFIX%\Scripts\gfortran.exe

:: http://superuser.com/questions/375029/make-interrupt-exception-caught
python -c "a=open('Makefile').read(); f=open('Makefile', 'w'); f.write('SHELL=C:/Windows/System32/cmd.exe\n'); f.write(a)"
make

mkdir -p %PREFIX%\Scripts\
cp packmol.exe %PREFIX%\Scripts\
