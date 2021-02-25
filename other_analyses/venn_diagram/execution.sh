#! /usr/bin/env bash

#module load R/4.0.2

#PATH TO inputfiles
input_file1=PATH_TO_INPUT_FILE1
input_file2=PATH_TO_INPUT_FILE2

#Change diagram colors and names of the different datasets in the script

get_venndiagram.R -i $input_file1 -I $input_file2 -c COLUMN_WITH_DATA1 -C COLUMN_WITH_DATA2  -t "MAIN TITLE" -o "output_name.png"