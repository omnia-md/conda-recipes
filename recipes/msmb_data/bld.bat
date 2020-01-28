mkdir "%PREFIX%\share\"
xcopy msmb_data "%PREFIX%\share\msmb_data" /e /i /y
if errorlevel 1 exit 1
