#! /usr/bin/env python


##############################################################################################################################################
#                                                           OPTPARSE
##############################################################################################################################################
import optparse

parser=optparse.OptionParser()

parser.add_option("-f", "--file", dest="data_file", 
                  help="file", metavar="FILE")

parser.add_option("-c", "--column id ", dest="column", 
                  help="column which have clusters identificators", type='int')

parser.add_option("-n", "--net_name", dest="net_name", 
                  help="net_name", type='str')

parser.add_option("-t", "--net_type", dest="net_type", 
                  help="net_type", type='str')

parser.add_option("-a", "--analysis", dest="analysis", 
                  help="analysis", type='str')


(options, arg) = parser.parse_args()

#######################################################################################################################################
#                                                       MAIN
#######################################################################################################################################
coocurrent = 0
no_coocurrent = 0

file = open(options.data_file)

for line in file:
	line = line.rstrip("\n")

	field = line.split("\t")
	pvalue = float(field[options.column])

	if pvalue <= 0.05 :
		coocurrent = coocurrent + 1
		
	else:
		no_coocurrent = no_coocurrent + 1



print(options.net_name, options.net_type,  "number_coocurrent_pairs_" + options.analysis, str(coocurrent), sep="\t")
print(options.net_name, options.net_type,  "number_non_coocurrent_pairs_" + options.analysis, str(no_coocurrent), sep="\t")