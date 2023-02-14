#!/usr/bin/env sh

#
# PC-x86-64 QEMU.
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

SCRIPT_FILENAME=$(basename "$0")

################################################################################
# tcpport_is_listening()                                                       #
#                                                                              #
# $1 = port                                                                    #
# $2 = timeout in 1 ms units                                                   #
# $3 = error message prefix (empty = no message); example: "*** Error"         #
################################################################################
tcpport_is_listening()
{
_time_start=$(date +%s)
while true ; do
  _port_listening=$(netstat -l -t --numeric-ports | grep -c "^tcp.*localhost:$1.*LISTEN.*\$")
  [ "${_port_listening}" -eq 1 ] && break
  _time_current=$(date +%s)
  if [ $((_time_current-_time_start)) -gt $2 ] ; then
    if [ "x$3" != "x" ] ; then
      printf "$3: timeout waiting for port $1.\n"
    fi
    return 1
  fi
  sleep 1
done
return 0
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

# QEMU executable
QEMU_EXECUTABLE="/opt/sweetada/bin/qemu-system-x86_64"

# debug options
if [ "x$1" = "x-debug" ] ; then
  QEMU_SETSID="setsid"
  QEMU_DEBUG="-S -gdb tcp:localhost:1234,ipv4"
else
  QEMU_SETSID=
  QEMU_DEBUG=
fi

# telnet ports
MONITORPORT=4445
SERIALPORT0=4446
SERIALPORT1=4447

# QEMU machine
${QEMU_SETSID} "${QEMU_EXECUTABLE}" \
  -M q35 -cpu core2duo -m 256 -vga std \
  -monitor "telnet:localhost:${MONITORPORT},server,nowait" \
  -rtc "base=utc,clock=host" \
  -chardev "socket,id=SERIALPORT0,port=${SERIALPORT0},host=localhost,ipv4=on,server=on,telnet=on,wait=on" \
  -serial "chardev:SERIALPORT0" \
  -chardev "socket,id=SERIALPORT1,port=${SERIALPORT1},host=localhost,ipv4=on,server=on,telnet=on,wait=on" \
  -serial "chardev:SERIALPORT1" \
  -drive "if=floppy,format=raw,file=${PLATFORM_DIRECTORY}/pcbootfd.dsk" -boot a \
  ${QEMU_DEBUG} \
  &
QEMU_PID=$!

# console for serial port
tcpport_is_listening ${SERIALPORT0} 3 "*** Error"
setsid /usr/bin/xterm \
  -T "QEMU-1" -geometry 80x24 -bg blue -fg white -sl 1024 -e \
  /bin/telnet localhost ${SERIALPORT0} \
  &
# console for serial port
tcpport_is_listening ${SERIALPORT1} 3 "*** Error"
setsid /usr/bin/xterm \
  -T "QEMU-2" -geometry 80x24 -bg blue -fg white -sl 1024 -e \
  /bin/telnet localhost ${SERIALPORT1} \
  &

# normal execution or debug execution
if [ "x$1" = "x" ] ; then
  wait ${QEMU_PID}
elif [ "x$1" = "x-debug" ] ; then
  "${GDB}" \
    -q \
    -iex "set basenames-may-differ" \
    -iex "set language ada" \
    ${KERNEL_OUTFILE} \
    -ex "target remote tcp:localhost:1234" \
    -ex "break bsp_setup" -ex "continue"
fi

exit 0

