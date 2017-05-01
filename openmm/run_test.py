#!/usr/bin/env python

from simtk import openmm

# Check major version number
assert openmm.Platform.getOpenMMVersion() == '7.1', "openmm.Platform.getOpenMMVersion() = %s" % openmm.Platform.getOpenMMVersion()

# Check git hash
assert openmm.version.git_revision == '4b6fad2c19ea87a117b37969e96c99ffcbcf38e3', "openmm.version.git_revision = %s" % openmm.version.git_revision
