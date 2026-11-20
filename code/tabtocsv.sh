#!/bin/bash
# Author: Aiyanuj <aw2923@ic.ac.uk>
# Script: tabtocsv.sh
# Desc: substitute the tabs in the files with commas
#       saves the output into a .csv file
# Arguments: 1-> tab delimited file
# Date: 8 Oct 2025


# check for valid input file

if [[ "$#" -ne 1 ]]; then
    printf 'Error: Exactly one input file is required \n' >&2
    printf 'Usage: $0 input_file \n' >&2
    exit 1
fi

if [[ ! -e "$1" ]]; then
    printf 'Error: Invalid input %s\n' "$1" >&2
    exit 2
fi

if [[ ! -r "$1" ]]; then
    printf 'Error: Unreadable input %s\n' "$1" >&2
    exit 3
fi


# create and save the comma delimited file

printf "Creating a comma delimited version of $1 ... \n"

cat "$1" | tr "\t" "," > "$1.csv"

printf "Output content: "
head -5 "$1.csv"

mkdir -p results
mv "$1.csv" results

output_file="results/$(basename "$1").csv"

if [[ ! -f "$output_file" ]]; then
    printf 'Error: Expected output file not found in the results directory' >&2
    exit 4
fi

printf "Output saved in $output_file \n"

exit 0