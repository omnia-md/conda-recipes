make
mkdir -p $PREFIX/share/ $PREFIX/bin
cp -r . $PREFIX/share/shiftx2
cat <<EOF > $PREFIX/bin/shiftx2.py
#!/usr/bin/env python
import sys
import os
os.environ['PYTHONPATH'] = '$PREFIX/share/shiftx2'
os.system(' '.join(['/usr/bin/python2', '$PREFIX/share/shiftx2/shiftx2.py'] + sys.argv[1:]))
EOF
