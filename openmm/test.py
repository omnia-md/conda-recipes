#!/usr/bin/env python

from simtk import openmm

# Check major version number
assert openmm.Platform.getOpenMMVersion() == '7.0', "openmm.Platform.getOpenMMVersion() = %s" % openmm.Platform.getOpenMMVersion()

# Check git hash
assert openmm.version.git_revision == '5e86c4f76cb8e40e026cc78cdc452cc378151705', "openmm.version.git_revision = %s" % openmm.version.git_revision
