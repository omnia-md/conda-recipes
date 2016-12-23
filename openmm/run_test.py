#!/usr/bin/env python

from simtk import openmm

# Check major version number
assert openmm.Platform.getOpenMMVersion() == '7.1', "openmm.Platform.getOpenMMVersion() = %s" % openmm.Platform.getOpenMMVersion()

# Check git hash
assert openmm.version.git_revision == '1e5b258c0df6ab8b4350fd2c3cbf6c6f7795847c', "openmm.version.git_revision = %s" % openmm.version.git_revision
