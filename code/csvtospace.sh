#!/bin/bash
# Author: Aiyanuj <aw2923@ic.ac.uk>
# Script: csvtospace.sh
# Desc: substitute the commas in the files with spaces
#       saves the output into a .txt file
# Arguments: 1-> comma delimited file
# Date: 8 Oct 2025

if [[ ! -e "$1" ]]; then
    echo 'Invalid input: %s\n' "$1" >&2
    exit 2
fi

if [[ ! -r "$1" ]]; then
    echo 'Unreadable input: %s\n' "$1" >&2
    exit 1
fi


echo "Creating a space delimited version of $1 ..."

cat "$1" | tr "," " " > "$1.txt"

echo "Output (first 10 lines): "
head -10 "$1.txt"

mkdir ../results
mv "$1.txt" ../results

echo "Saved to: ../results"

exit 0