#!/usr/bin/env python
"""
Generator file for the YAML scripts Conda-build will use

Set the PYTHONS, CUDAS, and NumPy version and go
"""

import re
import ruamel.yaml  # This gets installed with conda-build


PYTHONS = [3.6, 3.7, 3.8]
CUDAS = [8.0, 9.0, 9.1, 9.2, 10.0, 10.1, 10.2]
NUMPY = 1.14
MACOSX_DEPLOY = 10.9

dumper_keys = {"indent": 4, "block_seq_indent": 2}
dumper = ruamel.yaml.round_trip_dump


def dump_indent_add_lines(data):
    """Helper function, adds indentation to output, empty lines between top-level keys"""
    stream = dumper(data, **dumper_keys)
    formatted = re.sub(r"\n^([a-zA-Z])", r"\n\n\1", stream, flags=re.MULTILINE)
    return formatted


def gen_yamls():
    for python in PYTHONS:
        no_cuda_dict = {"python": [python], "numpy": [NUMPY], "MACOSX_DEPLOYMENT_TARGET": [MACOSX_DEPLOY]}
        with open(f"python{python}.yaml", 'w') as f:
            f.write(dump_indent_add_lines(no_cuda_dict))
        for cuda in CUDAS:
            cuda_short = int(str(cuda).replace('.', ''))
            cuda_dict = {**no_cuda_dict, "CUDA_SHORT_VERSION": [cuda_short], "CUDA_VERSION": [cuda]}
            with open(f"python{python}_cuda{cuda}.yaml", 'w') as f:
                f.write(dump_indent_add_lines(cuda_dict))


if __name__ == "__main__":
    gen_yamls()
