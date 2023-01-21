#!/usr/bin/env sh

#
# QEMU-RISC-V QEMU configuration file.
#

# QEMU executable
if [ "x${RISCV32}" = "xY" ] ; then
  QEMU_EXECUTABLE="/opt/sweetada/bin/qemu-system-riscv32"
fi

# telnet ports
MONITORPORT=4445
SERIALPORT0=4446
SERIALPORT1=4447

# console for serial port
/usr/bin/xterm \
  -T "QEMU-1" -geometry 80x24 -bg blue -fg white -sl 1024 -e \
  /bin/telnet localhost ${SERIALPORT0} \
  &
# console for serial port
/usr/bin/xterm \
  -T "QEMU-2" -geometry 80x24 -bg blue -fg white -sl 1024 -e \
  /bin/telnet localhost ${SERIALPORT1} \
  &

# QEMU machine
"${QEMU_EXECUTABLE}" \
  -M virt \
  -bios "${SWEETADA_PATH}"/${KERNEL_ROMFILE} \
  -monitor "telnet:localhost:${MONITORPORT},server,nowait" \
  -chardev "socket,id=SERIALPORT0,port=${SERIALPORT0},host=localhost,ipv4=on,server=on,telnet=on,wait=off" \
  -serial "chardev:SERIALPORT0" \
  -chardev "socket,id=SERIALPORT1,port=${SERIALPORT1},host=localhost,ipv4=on,server=on,telnet=on,wait=off" \
  -serial "chardev:SERIALPORT1"

exit 0

