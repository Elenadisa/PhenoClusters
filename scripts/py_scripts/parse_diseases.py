#! /usr/bin/env python

##############################################################################################################################################
#															METHODS
##############################################################################################################################################
def load_disease_file(filename, key_col_number, value_col_number):
	dictionary = {}
	file = open(filename).readlines()[1:]
	
	for line in file:
		line = line.rstrip("\n")
		fields = line.split("\t")
		key = fields[key_col_number]
		value = fields[value_col_number]

		if key not in dictionary:
			dictionary[key] = [value]
		else :
			dictionary[key].append(value)

	return dictionary





##############################################################################################################################################
#															OPTPARSE
##############################################################################################################################################
import optparse

parser = optparse.OptionParser()

parser.add_option("-d", "--diseases file", dest="diseases",
                  help="Input diseases file", metavar="FILE")
parser.add_option("-n", "--profiles", dest="profile",
                  help="Diseases patterns", metavar="FILE")
parser.add_option("-b", "--key_column_profile_id", dest="profile_id",
                  help="Diseases ids", type='int')
parser.add_option("-y", "--value_column_profile", dest="profile_value",
                  help="profile_value", type='int')
parser.add_option("-t", "--disease_type", dest="disease_type",
                  help="disease_type", type='str')



(options, args) = parser.parse_args()

###############################################################################################################################################
# 															MAIN
###############################################################################################################################################

profile_dictionary = load_disease_file(options.profile, options.profile_id, options.profile_value)
disease_type = options.disease_type

file = open(options.diseases)

if disease_type == "OMIM":
	for line in file:
		line = line.rstrip("\n")
		fields = line.split("\t")
		OMIM_id = "OMIM:"+ fields[1]

		if OMIM_id in profile_dictionary:
			for HPO in profile_dictionary[OMIM_id]:
				print(OMIM_id, HPO, sep="\t")


elif disease_type == "ORPHA":
	for line in file:
		line = line.rstrip("\n")
		fields = line.split("\t")
		ORPHA_id = fields[0]

		if ORPHA_id in profile_dictionary:
			for HPO in profile_dictionary[ORPHA_id]:
				print(ORPHA_id, HPO, sep="\t")

