from pkg_resources import iter_entry_points

entry_points = [
    *iter_entry_points(group="openforcefield.smirnoff_forcefield_directory")
]

assert len(entry_points) == 1

e = entry_points[0]

assert e.name == "get_forcefield_dirs_paths"
assert e.module_name == "smirnoff99frosst.smirnoff99frosst"
