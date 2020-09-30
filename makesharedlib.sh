#!/bin/bash
# Author: Johannes Buchner (C) 2015
# Modification: Marc Paterno (C) 2020
# For creating a shared library (libcuba.so).

os_string=$(uname)
if [[ "${os_string}" == "Darwin" ]]; then
  echo "I am on macOS"
elif [[ "${os_string}" == "Linux" ]]; then
  echo "I am on Linux"
else
  echo "Neither Darwin (macOS) nor Linux detected; aborting installation."
  exit 1
fi

sed 's/CFLAGS = -O3 -fomit-frame-pointer/CFLAGS = -O3 -fPIC -fomit-frame-pointer/g' --in-place makefile
echo "rebuilding libcuba.a archive"
make -B libcuba.a
echo "unpacking libcuba.a"
FILES=$(ar xv libcuba.a | sed 's/x - //g' | fgrep -v "__.SYMDEF")
echo "Making shared library"

LIBNAME=libcuba.so
if [[ "${os_string}" == "Darwin" ]]; then
  LIBNAME=libcuba.dylib
fi

gcc -shared -Wall $FILES -lm -o ${LIBNAME}
rm $FILES

