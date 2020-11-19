#! /usr/bin/env python

#get a comparitive table between HPO frequency of all omim and neuromuscular diseases.

import functions as fn


########################################################################################################################################
#														OPTPARSE
########################################################################################################################################
import optparse

parser=optparse.OptionParser()

parser.add_option("-a", "--all_file", dest="all_file", 
                  help="all diseases file", metavar="FILE")
parser.add_option("-x", "--hpo_name_col", dest="hpo_name_col", 
                  help="hpo name column", type='int')
parser.add_option("-B", "--all_key_col", dest="all_key_col", 
                  help="all diseases key column", type='int')
parser.add_option("-b", "--all_value_col", dest="all_value_col", 
                  help="all diseases value column", type='int')



parser.add_option("-y", "--all_non_neuromuscular", dest="non_neuromuscular_file", 
                  help="non_ diseases file", metavar="FILE")


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

#load_dictionary
all_diseases_dictionary = fn.build_dictionary(options.non_neuromuscular_file, options.neuromuscular_key_col, options.neuromuscular_value_col)
neuromuscular_diseases_dictionary = fn.build_dictionary(options.neuromuscular_file, options.neuromuscular_key_col, options.neuromuscular_value_col)
omim_dictionary = fn.build_dictionary(options.all_file, options.all_key_col, options.all_value_col)

hpo_dictionary = fn.build_dictionary(options.all_file, options.all_key_col, options.hpo_name_col)

#unique list of HPOs
unique_hpo_l = omim_dictionary.keys()

#test_dictionary
#print(all_diseases_dictionary)
#print(len(all_diseases_dictionary.keys()))

#print(neuromuscular_diseases_dictionary)
#print(len(neuromuscular_diseases_dictionary.keys()))

#print(hpo_dictionary)
#print(len(hpo_dictionary.keys()))


for hpo in unique_hpo_l:
	
	if hpo in all_diseases_dictionary and hpo in neuromuscular_diseases_dictionary:
		print(hpo, ",".join(hpo_dictionary[hpo]), ",".join(all_diseases_dictionary[hpo]), ",".join(neuromuscular_diseases_dictionary[hpo]), sep ="\t")

	elif hpo in all_diseases_dictionary and hpo not in neuromuscular_diseases_dictionary:
		print(hpo, ",".join(hpo_dictionary[hpo]), ",".join(all_diseases_dictionary[hpo]), str(0), sep ="\t")

	elif hpo not in all_diseases_dictionary and hpo in neuromuscular_diseases_dictionary:
		print(hpo, ",".join(hpo_dictionary[hpo]), str(0), ",".join(neuromuscular_diseases_dictionary[hpo]), sep ="\t")	
