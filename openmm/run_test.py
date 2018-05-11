#!/usr/bin/env python

from simtk import openmm

# Check major version number
# If Z=0 for version X.Y.Z, out put is "X.Y"
assert openmm.Platform.getOpenMMVersion() == '7.2.2', "openmm.Platform.getOpenMMVersion() = %s" % openmm.Platform.getOpenMMVersion()

# Check git hash
assert openmm.version.git_revision == '32bc79aa35da5495c9947ba817cb956964d63a4b', "openmm.version.git_revision = %s" % openmm.version.git_revision
