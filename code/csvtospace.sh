#!/bin/bash
# Author: Aiyanuj <aw2923@ic.ac.uk>
# Script: csvtospace.sh
# Desc: substitute the commas in the files with spaces
#       saves the output into a .txt file
# Arguments: 1-> comma delimited file
# Date: 8 Oct 2025


# check for valid input file

if [[ "$#" -ne 1 ]]; then
    printf "Error: Exactly one input file is required \n" >&2
    printf "Usage: $0 input_file \n" >&2
    exit 1
fi

if [[ ! -e "$1" ]]; then
    printf 'Error: Invalid input: %s\n' "$1" >&2
    exit 2
fi

if [[ ! -r "$1" ]]; then
    printf 'Error: Unreadable input: %s\n' "$1" >&2
    exit 3
fi


# create and save the space delimited file

printf "Creating a space delimited version of $1 ... \n"

cat "$1" | tr "," " " > "$1.txt"

printf "Output content (first 5 lines): \n"
head -5 "$1.txt"

mkdir -p results
mv "$1.txt" results

output_file="results/$(basename "$1").txt"

if [[ ! -f "$output_file" ]]; then
    printf 'Error: Expected output file not found in the results directory' >&2
    exit 4
fi

printf "Output saved in $output_file \n"

exit 0