#! /usr/bin/env python
##############################################################################################################################################
#															METHODS
##############################################################################################################################################
def load_pair_files(filename, index_col_number, hp_col_number):
	dictionary = {}
	file = open(filename)
	for line in file:
		line = line.rstrip("\n")
		fields = line.split("\t")
		index = fields[index_col_number]
		hp = fields[hp_col_number]

		if index not in dictionary:
			dictionary[index] = [hp]
		else :
			dictionary[index].append(hp)

	return dictionary


##############################################################################################################################################
#															OPTPARSE
##############################################################################################################################################
import optparse
parser = optparse.OptionParser()
parser.add_option("-c", "--cluster file", dest="dictionary",
                  help="Input file with the clusters of a network", metavar="FILE")
parser.add_option("-A", "--cluster_id", dest="cluster_id", 
                  help="column which have clusters identificators", type='int')
parser.add_option("-B", "--item_id", dest="item_id", 
                  help="column which have HPO o disease identificators", type='int')
parser.add_option("-m", "--model", dest="model_type",
                  help="network_type", metavar="str")
parser.add_option("-n", "--model_name", dest="model_name",
                  help="network_name", metavar="str")
parser.add_option("-e", "--enrichment_type", dest="enrichment",
                  help="type of enrichment", metavar="str")
parser.add_option("-p", "--p_value", dest="pvalue",
                  help="pvalue", metavar="float")


(options, args) = parser.parse_args()

###############################################################################################################################################
# 															MAIN
###############################################################################################################################################
import numpy as np
import os.path as path

#If the principal file exits it makes a dictionary cluster HPO
if path.exists(options.dictionary):    #if the dictionary has a length different to 0 append the length of every cluster in the empty list, esle append 0.
	dictionary = load_pair_files(options.dictionary, options.cluster_id, options.item_id)

	size = []		#empty list
	if int(len(dictionary)) != 0:		
		for cluster_id in dictionary:
			size.append(len(dictionary[cluster_id]))
	else:
		size.append(0)
	 
	mean = np.mean(size) #Calculate the mean of the clusters length

else :					#If the dictionary has length 0 the mean of clusters size is 0
	mean = 0

if options.enrichment and options.pvalue:
	print(options.model_name + "\t" + options.model_type + "\t" + "Average_Cluster_size" + options.enrichment + "_" + options.pvalue + "\t" + str(mean))
else:
	print(options.model_name + "\t" + options.model_type + "\t" + "Average_Cluster_size" + "\t" + str(mean))