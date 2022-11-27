#!/usr/bin/env tclsh

#
# S-record download.
#
# Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = KERNEL_SRECFILE
# $2 = SERIALPORT_DEVICE
# $3 = BAUD_RATE
#
# Environment variables:
# SWEETADA_PATH
# LIBUTILS_DIRECTORY
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

set SCRIPT_FILENAME [file tail $argv0]

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

source [file join $::env(SWEETADA_PATH) $::env(LIBUTILS_DIRECTORY) library.tcl]

if {[llength $argv] < 3} {
    puts stderr "$SCRIPT_FILENAME: *** Error: invalid number of arguments."
    exit 1
}

set kernel_srecfile [lindex $argv 0]
set serialport_device [lindex $argv 1]
set baud_rate [lindex $argv 2]

set serialport_fd [open $serialport_device "r+"]
fconfigure $serialport_fd \
    -blocking 0 \
    -buffering none \
    -eofchar {} \
    -mode $baud_rate,n,8,1 \
    -translation binary
flush $serialport_fd

# read kernel file and write to serial port
set kernel_fd [open $kernel_srecfile r]
fconfigure $kernel_fd -buffering line
# delay for processing of data on remote side
switch $baud_rate {
    "115200" {set delay 10}
    "38400"  {set delay 30}
    default  {set delay 50}
}
while {[gets $kernel_fd data] >= 0} {
    puts -nonewline $serialport_fd "$data\x0D\x0A"
    puts -nonewline stderr "."
    #puts stderr $data
    after $delay
    set srec_type [string range $data 0 1]
    if {$srec_type eq "S7"} {
        set start_address [string range $data 4 11]
    }
    if {$srec_type eq "S8"} {
        set start_address [string range $data 4 9]
    }
    if {$srec_type eq "S9"} {
        set start_address [string range $data 4 7]
    }
}
# close download of S-record data
puts -nonewline $serialport_fd "\x0D\x0A"
puts stderr ""
close $kernel_fd

close $serialport_fd

exit 0

