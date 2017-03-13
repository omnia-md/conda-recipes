#!/bin/bash

if [[ $(uname) == Darwin ]]; then
    export LDFLAGS="-headerpad_max_install_names $LDFLAGS"
fi

SETUPCFG=$SRC_DIR\setup.cfg

echo "[options]" > $SETUPCFG
echo "use_cython=True" >> $SETUPCFG
echo "[directories]" >> $SETUPCFG
echo "netCDF4_dir = $PREFIX" >> $SETUPCFG

${PYTHON} setup.py install --single-version-externally-managed --record record.txt