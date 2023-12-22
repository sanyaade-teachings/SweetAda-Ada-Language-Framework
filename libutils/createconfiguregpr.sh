#!/usr/bin/env sh

#
# Create "configure.gpr" GPRbuild project file.
#
# Copyright (C) 2020-2023 Gabriele Galeotti
#
# This work is licensed under the terms of the MIT License.
# Please consult the LICENSE.txt file located in the top-level directory.
#

#
# Arguments:
# $1 = configure project
# $2 = configure filename
#
# Environment variables:
# SWEETADA_PATH
# TOOLCHAIN_PREFIX
# GPRBUILD_PREFIX
# TOOLCHAIN_NAME
# GCC_WRAPPER
# GNATADC_FILENAME
# LIBRARY_DIRECTORY
# OBJECT_DIRECTORY
# PLATFORM
# CPU
# RTS_PATH
# RTS
# PROFILE
# ADA_MODE
# OPTIMIZATION_LEVEL
# STACK_LIMIT
# GNATBIND_SECSTACK
# USE_LIBGCC
# USE_LIBM
# USE_LIBADA
# USE_CLIBRARY
# ADAC_SWITCHES_RTS
# CC_SWITCHES_RTS
# GCC_SWITCHES_PLATFORM
# LOWLEVEL_FILES_PLATFORM
# GCC_SWITCHES_LOWLEVEL_PLATFORM
# INCLUDE_DIRECTORIES
# IMPLICIT_ALI_UNITS
#

################################################################################
# Script initialization.                                                       #
#                                                                              #
################################################################################

SCRIPT_FILENAME=$(basename "$0")
LOG_FILENAME=""
if [ "x${LOG_FILENAME}" != "x" ] ; then
  rm -f "${LOG_FILENAME}"
  touch "${LOG_FILENAME}"
fi

################################################################################
# log_print()                                                                  #
#                                                                              #
################################################################################
log_print()
{
if [ "x${LOG_FILENAME}" != "x" ] ; then
  printf "%s\n" "$1" | tee -a "${LOG_FILENAME}"
else
  printf "%s\n" "$1"
fi
return 0
}

################################################################################
# log_print_error()                                                            #
#                                                                              #
################################################################################
log_print_error()
{
if [ "x${LOG_FILENAME}" != "x" ] ; then
  printf "%s\n" "$1" | tee -a "${LOG_FILENAME}" 1>&2
else
  printf "%s\n" "$1" 1>&2
fi
return 0
}

################################################################################
# print_I()                                                                    #
#                                                                              #
# Print a string with amount of indentation proportional to INDENTATION_LEVEL. #
################################################################################
print_I()
{
_il=${INDENTATION_LEVEL}
_is=""
while [ "$((_il))" -gt 0 ] ; do
  _is="${_is}""${INDENTATION_ADA}"
  _il=$((_il-1))
done
printf "%s\n" "${_is}$1" >> "${CONFIGURE_FILENAME}"
return 0
}

################################################################################
# print_V()                                                                    #
#                                                                              #
# Print an empty line.                                                         #
################################################################################
print_V()
{
printf "%s\n" "" >> "${CONFIGURE_FILENAME}"
return 0
}

################################################################################
# print_list()                                                                 #
#                                                                              #
# Print a list of items with indentation.                                      #
################################################################################
print_list()
{
AWK_SCRIPT_FUNCTION='\
{                                                                        \
        ii = "";                                                         \
        for (i = 0; i < il; i++)                                         \
        {                                                                \
                ii = ii ia                                               \
        }                                                                \
        for (i = 1; i <= NF; i++)                                        \
        {                                                                \
                printf("%s%s\"%s\"%s\n", ii, is, $i, i != NF ? "," : "") \
        }                                                                \
}                                                                        \
'
printf "%s\n" "$1" |                  \
awk                                   \
  -v ia="${INDENTATION_ADA}"          \
  -v il="$2"                          \
  -v is="$3" "${AWK_SCRIPT_FUNCTION}" \
  >> "${CONFIGURE_FILENAME}"
return 0
}

################################################################################
# LFPL_list()                                                                  #
#                                                                              #
# Build a list of the source languages detected in LOWLEVEL_FILES_PLATFORM.    #
################################################################################
LFPL_list()
{
_LFP_S_files=
_LFP_C_files=
_LFPL_list=""
for f in "$@" ; do
  case ${f} in
    *.S)
      if [ ! "x${_LFP_S_files}" = "xY" ] ; then
        _LFP_S_files=Y
        _LFP_list="${_LFPL_list:+${_LFPL_list} }Asm_Cpp"
      fi
      ;;
    *.c)
      if [ ! "x${_LFP_C_files}" = "xY" ] ; then
        _LFP_C_files=Y
        _LFPL_list="${_LFPL_list:+${_LFPL_list} }C"
      fi
      ;;
  esac
done
printf "%s\n" "${_LFPL_list}"
return 0
}

################################################################################
# Main loop.                                                                   #
#                                                                              #
################################################################################

#
# Basic input parameters check.
#
CONFIGURE_PROJECT="$1"
if [ "x${CONFIGURE_PROJECT}" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no project name specified."
  exit 1
fi
CONFIGURE_FILENAME="$2"
if [ "x${CONFIGURE_FILENAME}" = "x" ] ; then
  log_print_error "${SCRIPT_FILENAME}: *** Error: no project file specified."
  exit 1
fi

rm -f "${CONFIGURE_FILENAME}"
touch "${CONFIGURE_FILENAME}"

INDENTATION_ADA="   " # Ada 3-space indentation style

INDENTATION_LEVEL=0

#
# Initial empty line.
#
print_V

#
# Declare project.
#
print_I "abstract project ${CONFIGURE_PROJECT} is"
INDENTATION_LEVEL=$((INDENTATION_LEVEL+1))
print_V

#
# Configuration declarations.
#
print_I "SweetAda_Path                     := \"${SWEETADA_PATH}\";"
print_I "Toolchain_Prefix                  := \"${TOOLCHAIN_PREFIX}\";"
print_I "Gprbuild_Prefix                   := \"${GPRBUILD_PREFIX}\";"
print_I "Toolchain_Name                    := \"${TOOLCHAIN_NAME}\";"
print_I "GCC_Wrapper                       := \"${GCC_WRAPPER}\";"
print_I "GnatAdc_Filename                  := \"${GNATADC_FILENAME}\";"
print_I "Library_Directory                 := \"${LIBRARY_DIRECTORY}\";"
print_I "Object_Directory                  := \"${OBJECT_DIRECTORY}\";"
print_I "Platform                          := \"${PLATFORM}\";"
print_I "Cpu                               := \"${CPU}\";"
print_I "RTS_Path                          := \"${RTS_PATH}\";"
print_I "RTS                               := \"${RTS}\";"
print_I "Profile                           := \"${PROFILE}\";"
print_I "Ada_Mode                          := \"${ADA_MODE}\";"
print_I "Optimization_Level                := \"${OPTIMIZATION_LEVEL}\";"
print_I "Stack_Limit                       := \"${STACK_LIMIT}\";"
print_I "Gnatbind_SecStack                 := \"${GNATBIND_SECSTACK}\";"
print_I "Use_LibGCC                        := \"${USE_LIBGCC}\";"
print_I "Use_Libm                          := \"${USE_LIBM}\";"
print_I "Use_LibAda                        := \"${USE_LIBADA}\";"
print_I "Use_CLibrary                      := \"${USE_CLIBRARY}\";"
INDENTL="                                      "
print_I "ADAC_Switches_RTS                 := ("
print_list "${ADAC_SWITCHES_RTS}" "${INDENTATION_LEVEL}" "${INDENTL}"
print_I "                                     );"
print_I "CC_Switches_RTS                   := ("
print_list "${CC_SWITCHES_RTS}" "${INDENTATION_LEVEL}" "${INDENTL}"
print_I "                                     );"
print_I "GCC_Switches_Platform             := ("
print_list "${GCC_SWITCHES_PLATFORM}" "${INDENTATION_LEVEL}" "${INDENTL}"
print_I "                                     );"
print_I "Lowlevel_Files_Platform           := ("
print_list "${LOWLEVEL_FILES_PLATFORM}" "${INDENTATION_LEVEL}" "${INDENTL}"
print_I "                                     );"
print_I "Lowlevel_Files_Platform_Languages := ("
print_list "$(LFPL_list ${LOWLEVEL_FILES_PLATFORM})" "${INDENTATION_LEVEL}" "${INDENTL}"
print_I "                                     );"
print_I "GCC_Switches_Lowlevel_Platform    := ("
print_list "${GCC_SWITCHES_LOWLEVEL_PLATFORM}" "${INDENTATION_LEVEL}" "${INDENTL}"
print_I "                                     );"
print_I "Include_Directories               := ("
print_list "${INCLUDE_DIRECTORIES}" "${INDENTATION_LEVEL}" "${INDENTL}"
print_I "                                     );"
print_I "Implicit_ALI_Units                := ("
print_list "${IMPLICIT_ALI_UNITS}" "${INDENTATION_LEVEL}" "${INDENTL}"
print_I "                                     );"
print_V

#
# Close project.
#
INDENTATION_LEVEL=$((INDENTATION_LEVEL-1))
print_I "end ${CONFIGURE_PROJECT};"

log_print "${SCRIPT_FILENAME}: ${CONFIGURE_FILENAME}: done."

exit 0

