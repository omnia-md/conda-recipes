:: on windows,
:: return {'libraries': ['C:\\Miniconda\\lib\\libf2c', 'C:\\Miniconda\\lib\\blas', 'C:\\Miniconda\\lib\\lapack',]}

SET LAPACK_LIBS="%PREFIX%\\lib\\libf2c %PREFIX%\\lib\\blas %PREFIX%\\lib\\lapack"

"%PYTHON%" setup.py install
if errorlevel 1 exit 1
