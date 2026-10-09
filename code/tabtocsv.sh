#!/bin/bash
# Author: Aiyanuj <aw2923@ic.ac.uk>
# Script: tabtocsv.sh
# Desc: substitute the tabs in the files with commas
#       saves the output into a .csv file
# Arguments: 1-> tab delimited file
# Date: 8 Oct 2025

if [[ ! -e "$1" ]]; then
    echo 'Invalid input: %s\n' "$1" >&2
    exit 2
fi

if [[ ! -r "$1" ]]; then
    echo 'Unreadable input: %s\n' "$1" >&2
    exit 1
fi

echo "Creating a comma delimited version of $1 ..."

cat "$1" | tr "\t" "," > "$1.csv"

echo "Output: "
cat "$1.csv"

mkdir ../results
mv "$1.csv" ../results

echo "Saved to: ../results"


exit 0