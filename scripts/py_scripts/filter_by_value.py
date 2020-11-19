#! /usr/bin/env python

def filter_a_file(filename, column, threshold, filter_type):
	file = open(filename).readlines()
	firstLine = file.pop(0)

	for line in file:
		line= line.rstrip("\n")
		fields = line.split("\t")
		value = fields[column]

		if filter_type == "greater than":
			if float(value )> threshold:
				print(line)
		elif filter_type == "greater or equal than":
			if float(value) >= threshold:
				print(line)
		elif filter_type == "less than":
			if float(value) < threshold:
				print(line)
		elif filter_type == "less or equal than":
			if float(value) <= threshold:
				print(line)






########################################################################################################################################
#														OPTPARSE
########################################################################################################################################
import optparse

parser=optparse.OptionParser()

parser.add_option("-i", "--input_file", dest="input_file", 
                  help="input file", metavar="FILE")
parser.add_option("-c", "--column_to_filter", dest="column_to_filter", 
                  help="column which has the values to be filter", type='int')
parser.add_option("-t", "--threshold", dest="threshold", 
                  help="threshold value", type='float')
parser.add_option("-f", "--filter", dest="filter_type", 
                  help="filter_type", type='str')

(options, arg) = parser.parse_args()

#######################################################################################################################################
#														MAIN
#######################################################################################################################################


filtered_df = filter_a_file(options.input_file, options.column_to_filter, options.threshold, options.filter_type)

