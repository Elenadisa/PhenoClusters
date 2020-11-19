#! /usr/bin/env python

import functions as fn

########################################################################################################################################
#														OPTPARSE
########################################################################################################################################
import optparse

parser=optparse.OptionParser()


parser.add_option("-a", "--all_file", dest="all_file", 
                  help="all diseases file", metavar="FILE")
parser.add_option("-b", "--all_value_col", dest="all_value_col", 
                  help="all diseases value column", type='int')
parser.add_option("-x", "--hpo_name_col", dest="hpo_name_col", 
                  help="hpo name column", type='int')

parser.add_option("-n", "--neuromuscular_file", dest="neuromuscular_file", 
                  help="neuromuscular diseases file", metavar="FILE")
parser.add_option("-C", "--neuromuscular_key_col", dest="neuromuscular_key_col", 
                  help="neuromuscular diseases key column", type='int')
parser.add_option("-c", "--neuromuscular_value_col", dest="neuromuscular_value_col", 
                  help="neuromuscular diseases value column", type='int')
(options, arg) = parser.parse_args()

#######################################################################################################################################
#														MAIN
#######################################################################################################################################
all_diseases_dictionary = fn.build_dictionary(options.all_file, options.all_value_col, options.hpo_name_col)
neuromuscular_diseases_dictionary = fn.build_dictionary(options.neuromuscular_file, options.neuromuscular_key_col, options.neuromuscular_value_col)

for disease, hpo_l in all_diseases_dictionary.items():
	if disease not in neuromuscular_diseases_dictionary:
		for hpo in hpo_l:
			print(disease, hpo, sep="\t")

