#!/usr/bin/env sh

# create an S-record kernel file for 162Bug download
${OBJCOPY}                                 \
  -O srec                                  \
  ${SWEETADA_PATH}/${KERNEL_OUTFILE}       \
  ${SWEETADA_PATH}/${KERNEL_BASENAME}.srec

exit $?

