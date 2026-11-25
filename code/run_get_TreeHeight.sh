#!/usr/bin/env bash
# Author : Aiyanuj <aw2923@ic.ac.uk>
# Script: run_get_TreeHeight.sh
# Desc: run the get_TreeHeight.R script to calculate tree heights from input data/trees.csv

set -e

Rscript code/get_TreeHeight.R data/trees.csv

exit 0
