gfortran cenmass.f gencan.f initial.f io.f fgcommon.f packmolnew.f polartocart.f heuristics.f feasy.f geasy.f -o packmol
mkdir -p %PREFIX%\bin\
cp packmol.exe %PREFIX%\bin\