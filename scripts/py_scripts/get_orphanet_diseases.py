#! /usr/bin/env python

def parse_ontology(filename):
	file = open(filename)
	parent_child_dict = dict()
	name_dict = dict()
	disease_dict = dict()
	
	for line in file:
		line = line.rstrip("\n")
		fields = line.split(": ")
		
		if fields[0] == "id" :
			term = fields[1]
			if term not in name_dict:
				name_dict[term] = []

		elif fields[0] == "name" :
			name = fields[1]
			name_dict[term].append(name)

		elif fields[0] == "is_a":
			parent_line = fields[1]
			parent_fields = parent_line.split(" ")
			parent_term = parent_fields[0]
			if parent_term not in parent_child_dict:
				parent_child_dict[parent_term] = []
				parent_child_dict[parent_term].append(term)
			else:
				parent_child_dict[parent_term].append(term)

		elif fields[0] == "relationship":
			category_line = fields[1]
			category_line = category_line.split(" ")
			
			if str(category_line[0]) == "part_of":
				class_id = category_line[1]
				if class_id not in disease_dict:
					disease_dict[class_id] = []
					disease_dict[class_id].append(term)
				else:
					disease_dict[class_id].append(term)

	return parent_child_dict, name_dict, disease_dict

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

parent_child_dict, name_dict, disease_dict = parse_ontology(options.obo_file)

#get a list of main terms
query_list = options.id_to_find.split(",")

#print(query_list)

#look for direct child terms and diseases in which the main terms are involved

for query in query_list:
	if query in parent_child_dict:
		query_childs_list = parent_child_dict[query]
		new_terms = query_childs_list.copy()
	else:
		query_childs_list = []
		new_terms = []

	
	#print(query_childs)
	#print(disease_list)

	#look for hierchical child terms
	while len(new_terms) != 0:
		new_list = [] #list to store child terms

		for term in new_terms:
			if term in parent_child_dict:
				query_childs_list.extend(parent_child_dict[term])
				new_list.extend(parent_child_dict[term])
			
		new_terms = new_list.copy()

	id_final_list = query_list + list(set(query_childs_list))

	#print(id_final_list)

	for id_term in id_final_list:
	
		if id_term in disease_dict:
			diseases = disease_dict[id_term]

			for disease in diseases:
				disease_name = name_dict[disease]
				disease = disease.split(":")
				print("ORPHA:" + disease[1], ",".join(disease_name), sep = "\t")