#!/usr/bin/env python

#
# OpenOCD code download.
#
# Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# -server   start OpenOCD server
# -shutdown shutdown OpenOCD server
#
# Environment variables:
# SWEETADA_PATH
# LIBUTILS_DIRECTORY
# OPENOCD_PREFIX
# PLATFORM_DIRECTORY
# ELFTOOL
# KERNEL_OUTFILE
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

import sys
# avoid generation of *.pyc
sys.dont_write_bytecode = True

SCRIPT_FILENAME = sys.argv[0]

################################################################################
#                                                                              #
################################################################################

import os
import subprocess
sys.path.append(os.path.join(os.getenv('SWEETADA_PATH'), os.getenv('LIBUTILS_DIRECTORY')))
import library
import libopenocd

# helper function
def printf(format, *args):
    sys.stdout.write(format % args)
# helper function
def errprintf(format, *args):
    sys.stderr.write(format % args)

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

OPENOCD_PREFIX  = os.getenv('OPENOCD_PREFIX')
OPENOCD_CFGFILE = os.path.join(os.getenv('SWEETADA_PATH'), os.getenv('PLATFORM_DIRECTORY'), 'openocd.cfg')
ELFTOOL         = os.getenv('ELFTOOL')
KERNEL_OUTFILE  = os.path.join(os.getenv('SWEETADA_PATH'), os.getenv('KERNEL_OUTFILE'))
START_SYMBOL    = '_start'

if len(sys.argv) > 1:
    if sys.argv[1] == '-server':
        platform = library.platform_get()
        if   platform == 'windows':
            OPENOCD_EXECUTABLE = os.path.join(OPENOCD_PREFIX, 'bin', 'openocd.exe')
            os.system('cmd.exe /C START ' + OPENOCD_EXECUTABLE + ' -f ' + OPENOCD_CFGFILE)
        elif platform == 'unix':
            OPENOCD_EXECUTABLE = os.path.join(OPENOCD_PREFIX, 'bin', 'openocd')
            os.system('xterm -hold -e \"' + OPENOCD_EXECUTABLE + ' -f ' + OPENOCD_CFGFILE + '\" &')
        else:
            errprintf('%s: *** Error: platform not recognized.\n', SCRIPT_FILENAME)
            exit(1)
        exit(0)

# local OpenOCD server
libopenocd.openocd_rpc_init('127.0.0.1', 6666)

if len(sys.argv) > 1:
    if sys.argv[1] == '-shutdown':
        libopenocd_rpc_tx('shutdown')
        exit(0)

elftool_command = [ELFTOOL, '-c', 'findsymbol=' + START_SYMBOL, KERNEL_OUTFILE]
if library.is_python3():
    result = subprocess.run(elftool_command, stdout=subprocess.PIPE).stdout.decode('utf-8').strip()
else:
    result = subprocess.check_output(elftool_command).strip()
# ARM Thumb functions have LSB = 1
START_ADDRESS = '0x{:X}'.format(int(result, base=16) & 0xFFFFFFFE)
printf('START ADDRESS = %s\n', START_ADDRESS)

libopenocd.openocd_rpc_tx('halt')
libopenocd.openocd_rpc_rx('echo')
library.msleep(1000)
libopenocd.openocd_rpc_tx('load_image' + ' ' + KERNEL_OUTFILE)
libopenocd.openocd_rpc_rx('echo')
libopenocd.openocd_rpc_tx('resume' + ' ' + START_ADDRESS)
libopenocd.openocd_rpc_rx('echo')

libopenocd.openocd_rpc_disconnect()

exit(0)

