#!/bin/bash
# Author: Aiyanuj <aw2923@ic.ac.uk>
# Script: tabtocsv.sh
# Desc: substitute the tabs in the files with commas
#       saves the output into a .csv file
# Arguments: 1-> tab delimited file
# Date: 8 Oct 2025

if [ -z "$1" ]; then
    echo 'Invalid input: %s\n' "$1" >&2
    exit 1
fi


echo "Creating a comma delimited version of $1 ..."

mkdir -p ../results

cat "$1" | tr "\t" "," > "../results/$1.csv"

echo "Saved to: ../results/$1.csv"

cat "../results/$1.csv"


exit 0