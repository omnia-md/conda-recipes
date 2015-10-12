IF EXIST OpenBLAS_mingwpy_amd64.7z (
  "C:\Program Files\7-Zip\7z" x OpenBLAS_mingwpy_amd64.7z
)
IF EXIST OpenBLAS_mingwpy-win32.7z (
  "C:\Program Files\7-Zip\7z" x OpenBLAS_mingwpy-win32.7z
)

xcopy include\* %LIBRARY_INC%\
xcopy lib\*     %LIBRARY_LIB%\
xcopy bin\*     %LIBRARY_BIN%\
