#!/usr/bin/env python

from simtk import openmm

# Check major version number
assert openmm.Platform.getOpenMMVersion() == '7.1', "openmm.Platform.getOpenMMVersion() = %s" % openmm.Platform.getOpenMMVersion()

# Check git hash
# TODO: Reactivate when no longer using a patch to publish docs from 7.1
# assert openmm.version.git_revision == '9567ddb304c48d336e82927adf2761e8780e9270', "openmm.version.git_revision = %s" % openmm.version.git_revision
