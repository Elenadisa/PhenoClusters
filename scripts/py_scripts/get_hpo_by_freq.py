#! /usr/bin/env python
# Search for hpo with similar frequency than a given list of hpo

import functions as fn
import random

def build_dictionary(filename, key_col, value_col, hpo_l):
	dictionary = dict()

	file = open(filename)

	for line in file:
		line = line.rstrip("\n")
		fields = line.split("\t")
		key = fields[key_col]
		value = fields[value_col]

		if key not in dictionary:
			dictionary[key] = []
			if value not in hpo_l:
				dictionary[key].append(value)
		else:
			if value not in hpo_l:
				dictionary[key].append(value)
	return(dictionary)

def calculate_percentage(percentage, value):
	freq_list = []
	nb = int(round(((percentage * value) / 100), 0))
	freq_list.append(value)
	for i in range(1, nb):
		freq_list.append(value + i)
		freq_list.append(value - i)
	#print(percentage, value, nb, freq_list, sep="\t")
	return(freq_list)


##############################################################################################################################################
#															OPTPARSE
##############################################################################################################################################
import optparse

parser=optparse.OptionParser()

parser.add_option("-l", "--hpo_list", dest="hpo_list", 
                  help="file with a list of hpo", metavar="FILE")

parser.add_option("-n", "--neuromuscular_frequency_table", dest="neuromuscular_frequency_table", 
				  help="file with hpo frequency table", metavar="FILE")
parser.add_option("-N", "--non_neuromuscular_frequency_table", dest="non_neuromuscular_frequency_table", 
				  help="file with hpo frequency table", metavar="FILE")

parser.add_option("-i", "--hpo_id_col", dest="hpo_id", 
                  help="column which have hpo id", type='int')
parser.add_option("-A", "--non_neuromuscular_freq", dest="freq_col", 
                  help="column which have non neuromuscular frequency", type='int')

parser.add_option("-p", "--percentage", dest="percentage", 
                  help="percentage", type='int')

(options, arg) = parser.parse_args()

#######################################################################################################################################
#														MAIN
#######################################################################################################################################
neuromuscular_freq_dictionary = fn.build_dictionary(options.neuromuscular_frequency_table, options.hpo_id, options.freq_col)
#print(neuromuscular_freq_dictionary)


hpo_neuromuscular_l = fn.load_list_from_a_file(options.hpo_list)
#print(len(hpo_neuromuscular_l))

freq_non_neuromuscular_dictionary = build_dictionary(options.non_neuromuscular_frequency_table, options.freq_col, options.hpo_id, hpo_neuromuscular_l)
#print(freq_non_neuromuscular_dictionary)


non_neuromuscular_hpo_l = []

for hpo in hpo_neuromuscular_l:
	if hpo in neuromuscular_freq_dictionary:
		freq = int("".join(neuromuscular_freq_dictionary[hpo]))
		#freq_list.append(freq)
		#freq_list.append(freq + 1)
		#freq_list.append(freq - 1)
		#freq_list.append(freq + 2)
		#freq_list.append(freq - 2)
		freq_list = calculate_percentage(options.percentage, freq)
		
		hpo_list = []
		for frequency in freq_list:
			if str(frequency) in freq_non_neuromuscular_dictionary:
				#print(hpo, freq, frequency, freq_non_neuromuscular_dictionary[str(frequency)], sep="\t")
				hpo_list.extend(freq_non_neuromuscular_dictionary[str(frequency)])
		#print(hpo, hpo_list, sep="\t")
		rd_hpo = random.choice(hpo_list)
		
		if rd_hpo not in non_neuromuscular_hpo_l:
			non_neuromuscular_hpo_l.append(rd_hpo)
			print(rd_hpo)
		else:
			while rd_hpo in non_neuromuscular_hpo_l:
				rd_hpo = random.choice(hpo_list)

			non_neuromuscular_hpo_l.append(rd_hpo)
			print(rd_hpo)
		


