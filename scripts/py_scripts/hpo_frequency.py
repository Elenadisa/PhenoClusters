#! /usr/bin/env python

def build_dictionary(filename, key_col, value_col):
	dictionary = {}
	file = open(filename)
	
	for line in file:
		if not line.startswith("#"):
			line = line.rstrip("\n")
			fields = line.split("\t")
			keys = fields[key_col]
			value = fields[value_col]

			if keys not in dictionary:
				dictionary[keys] = [value]
			else :
				dictionary[keys].append(value)

	#print(dictionary)
	return dictionary

##############################################################################################################################################
#															OPTPARSE
##############################################################################################################################################
import optparse
parser = optparse.OptionParser()
parser.add_option("-i", "--input", dest="input_file",
                  help="clusters_file", metavar="FILE")
parser.add_option("-a", "--key cluster", dest="key_col", 
                  help="key_cluster", type='int')
parser.add_option("-A", "--value cluster", dest="value_col", 
                  help="value_cluster", type='int')

parser.add_option("-n", "--hpo", dest="hpo_name",
                  help="hpo_file", metavar="FILE")
parser.add_option("-B", "--key hpo", dest="key_col_hpo", 
                  help="key_hpo", type='int')
parser.add_option("-b", "--value hpo", dest="value_col_hpo", 
                  help="value_hpo", type='int')
(options, args) = parser.parse_args()

###############################################################################################################################################
# 															MAIN
###############################################################################################################################################

hpo_freq = build_dictionary(options.input_file, options.key_col, options.value_col)
hpo_dictionary = build_dictionary(options.hpo_name, options.key_col_hpo, options.value_col_hpo)

for hpo, diseases_list in hpo_freq.items():

	if hpo in hpo_dictionary:
		print(hpo, "".join(hpo_dictionary[hpo]), len(diseases_list), sep="\t")