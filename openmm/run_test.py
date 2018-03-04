#!/usr/bin/env python

from simtk import openmm

# Check major version number
# If Z=0 for version X.Y.Z, out put is "X.Y"
assert openmm.Platform.getOpenMMVersion() == '7.2.1', "openmm.Platform.getOpenMMVersion() = %s" % openmm.Platform.getOpenMMVersion()

# Check git hash
assert openmm.version.git_revision == 'bbd662753892b446367aef8eebc3666466a34251', "openmm.version.git_revision = %s" % openmm.version.git_revision
