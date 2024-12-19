#!/bin/bash
# Copyright 2024 CS GROUP - https://www.csgroup.eu
# Copyright 2024 CNES - https://cnes.fr
# All rights reserved
# This file is provided under MIT license. See LICENSE file.

# Check if at least two files are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 file1_apt.txt file2_apt.txt ... target_apt.txt"
    exit 1
fi

# Get last file as target file
target_file="${@: -1}"

# Merge all files while removing duplicates
# - Ignore empty lines and comments
awk 1 "$@" | grep -v '^#' | grep -v '^$' | sort | uniq > merged_apt.txt

# Move merged file into target file
mv merged_apt.txt "$target_file"

echo "Merge done."
