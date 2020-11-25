#! /usr/bin/env python

def build_dictionary(filename):
	file = open(filename)
	category_dictionary = dict()
	disease_dictionary = dict()
	name_dictionary = dict()
	
	for line in file:
		line = line.rstrip("\n")
		fields = line.split(": ")
		
		if fields[0] == "id" :
			child = fields[1]
			if child not in name_dictionary:
				name_dictionary[child] = []
		
		elif fields[0] == "name" :
			name = fields[1]
			name_dictionary[child].append(name)

			
		elif fields[0] == "is_a":
			parental_line = fields[1]
			parental_fields = parental_line.split(" ")
			parental = parental_fields[0]
			if parental not in category_dictionary:
				category_dictionary[parental] = []
				category_dictionary[parental].append(child)
			else:
				category_dictionary[parental].append(child)
		
		elif fields[0] == "relationship":
			category_line = fields[1]
			category_line = category_line.split(" ")
			
			if str(category_line[0]) == "part_of":
				class_id = category_line[1]
				if class_id not in disease_dictionary:
					disease_dictionary[class_id] = []
					disease_dictionary[class_id].append(child)
				else:
					disease_dictionary[class_id].append(child)



	#print(category_dictionary)
	#print(disease_dictionary)
	return(category_dictionary, disease_dictionary, name_dictionary)



##############################################################################################################################################
#															OPTPARSE
##############################################################################################################################################
import optparse
parser = optparse.OptionParser()
parser.add_option("-o", "--obo_file", dest="obo_file",
                  help="obo_file", metavar="FILE")
parser.add_option("-s", "--id_to_find", dest="id_to_find", 
                  help="id_to_find", type='str')

(options, args) = parser.parse_args()

##############################################################################################################################################
#															MEHTODS
##############################################################################################################################################

term_child_dictionary, category_to_diseases_dictionary, name_dictionary = build_dictionary(options.obo_file)

neuromuscular_list = term_child_dictionary[options.id_to_find]

new_list = neuromuscular_list.copy()
new_terms = []

#print(type(neuromuscular_list))
#print(neuromuscular_list)

for classification_id in new_list:
	
	if classification_id in term_child_dictionary:
		neuromuscular_list.extend(term_child_dictionary[classification_id])
		new_terms.extend(term_child_dictionary[classification_id])

		#print(classification_id + "\t" + str(term_child_dictionary[classification_id]) +"\n" + "\n")

#while we find new child terms

while len(new_terms) != 0 :
	new_list = []

	for classification_id in new_terms:
		if classification_id in term_child_dictionary:
			neuromuscular_list.extend(term_child_dictionary[classification_id])
			new_list.extend(term_child_dictionary[classification_id])
			#print(classification_id + "\t" + str(term_child_dictionary[classification_id]) +"\n" + "\n")
	new_terms = new_list.copy()

category_final_list = list(set(neuromuscular_list.copy()))
#print(final_list)

for category in category_final_list:
	
	if category in category_to_diseases_dictionary:
		#print(category + "\t" + str(category_to_diseases_dictionary[category]) + "\n" + "\n")
		diseases = category_to_diseases_dictionary[category]

		for disease in diseases:
			disease_name = name_dictionary[disease]
			disease = disease.split(":")
			print("ORPHA:" + disease[1], ",".join(disease_name), sep = "\t")