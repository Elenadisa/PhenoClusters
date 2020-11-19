#! /usr/bin/env python

import functions as fn

##############################################################################################################################################
#															OPTPARSE
##############################################################################################################################################
import optparse

parser = optparse.OptionParser()

parser.add_option("-d", "--dictionary", dest="main_dictionary",
                  help="dictionary", metavar="FILE")
parser.add_option("-A", "--key_col", dest="key_col_dictionary", 
                  help="key id col for the main dictionary", type='int')
parser.add_option("-a", "--value_col", dest="value_col_dictionary", 
                  help="value col for main dictionary", type='int')
parser.add_option("-l", "--file to analyse", dest="file_to_analyse",
                  help="dictionary to analyse", metavar="FILE")
parser.add_option("-B", "--key_id", dest="key_col_analyse", 
                  help="key id col for the dictionary to analyse", type='int')

(options, args) = parser.parse_args()

###############################################################################################################################################
# 															MAIN
###############################################################################################################################################
hpo_dictionary = fn.build_dictionary(options.main_dictionary, options.key_col_dictionary, options.value_col_dictionary)

cluster_file = open(options.file_to_analyse)

print("hpo" + "\t" + "cluster" + "\t" + "name")

for line in cluster_file:
	line = line.rstrip("\n")
	HPO, cluster = line.split("\t")
	if HPO in hpo_dictionary:
		print(line + "\t" + "".join(hpo_dictionary[HPO]))