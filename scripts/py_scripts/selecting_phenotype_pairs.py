#! /usr/bin/env python

def load_pairs_dictionary(filename):
	file = open(filename)
	dictionary = dict()
	for line in file:
		line = line.rstrip("\n")
		hpo1, hpo2, HyI = line.split("\t")

		key = hpo1 + "-" + hpo2

		if key not in dictionary:
			dictionary[key] = [HyI]
	return(dictionary)

def load_list(filename):
	file = open(filename)
	hpo_l = []
	for line in file:
		line = line.rstrip("\n")
		hpo_l.append(line)
	return(hpo_l)
	

########################################################################################################################################
#														OPTPARSE
########################################################################################################################################
import optparse

parser=optparse.OptionParser()


parser.add_option("-p", "--pairs_file", dest="pairs_file", 
                  help="file with pairs list", metavar="FILE")

parser.add_option("-l", "--phenotype_list_file", dest="phenotype_list_file", 
                  help="file with phenotypes to select", metavar="FILE")

(options, arg) = parser.parse_args()

#######################################################################################################################################
#														MAIN
#######################################################################################################################################
pairs_dictionary = load_pairs_dictionary(options.pairs_file)
#print(pairs_dictionary)

phenotype_list = load_list(options.phenotype_list_file)
#print(phenotype_list)

for pairs, HyI in pairs_dictionary.items():
	hpoa, hpob = pairs.split("-")

	if hpoa in phenotype_list and hpob in phenotype_list:
		print(hpoa, hpob, "".join(HyI), sep="\t")
