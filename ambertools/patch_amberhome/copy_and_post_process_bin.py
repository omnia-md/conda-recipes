#!/usr/bin/env python

import os
from glob import glob
import subprocess
from itertools import chain

template = """
#!/usr/bin/env python

import os
import sys
import subprocess

os.environ['AMBERHOME'] = sys.prefix
{exe}_exe = os.path.join(sys.prefix, 'bin', '_{exe}')
commands = [{exe}_exe, ] + sys.argv[1:]
try:
    subprocess.call(commands)
except KeyboardInterrupt:
    pass
""".strip()

EXCLUDED_EXE = ['teLeap']

def post_process_exe_for_prefix_folder(exe_path):
    # always assuming having PREFIX env
    prefix_bin = os.getenv('PREFIX', '') + '/bin/'
    assert os.path.exists(prefix_bin)
    basename = os.path.basename(exe_path)
    subprocess.check_call(['cp', exe_path, prefix_bin + '_' +  basename])

    final_exe_path = prefix_bin + basename
    with open(final_exe_path, 'w') as fh:
        fh.write(template.format(exe=basename))
    subprocess.check_call(['chmod', '+x', final_exe_path])

def get_all_exe_paths_requiring_amberhome():
    amberhome = os.getenv('AMBERHOME', '')
    assert amberhome
    amber_bin = amberhome + '/bin/'

    all_exe = []
    for exe in glob(amber_bin + '*'):
        try:
            output = subprocess.check_output('grep "AMBERHOME is not set" {}'.format(exe),
                                             shell=True)
            output = output.decode()
        except subprocess.CalledProcessError:
            output = ''
        all_exe.extend([line.split()[2]
                       for line in output.split('\n') if 'matches' in line])
    return set(exe for exe in all_exe if exe)
    
def main():
    for exe_path in get_all_exe_paths_requiring_amberhome():
        if not any(word in exe_path for word in EXCLUDED_EXE):
            print('patching {}'.format(exe_path))
            post_process_exe_for_prefix_folder(exe_path)

if __name__ == '__main__':
    main()
