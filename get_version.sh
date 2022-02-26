#!/bin/bash

# Get version of LIBARY in every tagged release

LIBRARY=$1
echo "Getting package history for: $LIBRARY"
echo "========="

for crt_tag in $(git tag | tail -r)
do
  echo $crt_tag
  git checkout $crt_tag --quiet
  grep $LIBRARY pangeo-notebook/packages.txt
  echo "--"
done

git checkout master
