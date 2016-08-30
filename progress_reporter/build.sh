#!/bin/bash

$PYTHON setup.py bdist_wheel --universal
$PYTHON -m wheel install dist/*

