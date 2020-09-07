#!/bin/bash

# can alphabetize and omit build hash with:
# ../list_packages.sh | sort > packages.txt
EXPLICIT_LIST=`tail -n +4 conda-linux-64.lock`

# extract package name and versions
for LINE in ${EXPLICIT_LIST}; do
  URL_NOPRO=${LINE:7}
  FILENAME=${URL_NOPRO##/*/}
# just package name
# NAME=${FILENAME%%-*}
# package, version
  NAME=${FILENAME%-*}
# package,version, hash
#  NAME=$FILENAME%%.tar*}
  echo ${NAME}
done
