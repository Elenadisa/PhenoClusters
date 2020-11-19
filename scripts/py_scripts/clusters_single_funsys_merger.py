#! /usr/bin/env python

import functions as fn

def build_dictionary(filename, key_col, value_col, enrichment, gene_dictionary):
	file = open(filename)
	dictionary = dict()

	for line in file:
		line = line.rstrip("\n")
		fields = line.split("\t")

		key = fields[key_col]
		values = fields[value_col].split("/")

		if enrichment != "kegg":
			if key not in dictionary:
				dictionary[key] = []
				for value in values:
					if value not in dictionary[key]:
						dictionary[key].append(value)
			else:
				for value in values:
					if value not in dictionary[key]:
						dictionary[key].append(value)
		else:
			
			if key not in dictionary:
				dictionary[key] = []
				for value in values:
					if value not in dictionary[key]:
						if value in gene_dictionary:
							gene = "".join(gene_dictionary[value])
							dictionary[key].append(gene)
						
			else:
				for value in values:
					if value not in dictionary[key]:
						if value in gene_dictionary:
							gene = "".join(gene_dictionary[value])
							dictionary[key].append(gene)
						
	return(dictionary)

def build_hpo2gene_dictionary(filename, key_col, value_col, gene_dictionary):
	file = open(filename)
	dictionary = dict()

	for line in file:
		line = line.rstrip("\n")
		fields = line.split("\t")

		key = fields[key_col]
		values = fields[value_col].split("/")

		if key not in dictionary:
			dictionary[key] = []
			for value in values:
				if value not in dictionary[key]:
					if value in gene_dictionary:
						gene = "".join(gene_dictionary[value])
						dictionary[key].append(gene)
						
		else:
			for value in values:
				if value not in dictionary[key]:
					if value in gene_dictionary:
						gene = "".join(gene_dictionary[value])
						dictionary[key].append(gene)
						
	return(dictionary)


########################################################################################################################################
#														OPTPARSE
########################################################################################################################################
import optparse

parser=optparse.OptionParser()

parser.add_option("-c", "--cluster_file", dest="cluster_file", 
                  help="clustering.R output", metavar="FILE")
parser.add_option("-A", "--key_cluster", dest="key_cluster", 
                  help="column which have keys a file", type='int')
parser.add_option("-a", "--value_cluster", dest="value_cluster", 
                  help="column which have hpo values in a file", type='int')

parser.add_option("-x", "--single_enrichment", dest="enrichment_file", 
                  help="file with funtional systems result for single hpo", metavar="FILE")
parser.add_option("-B", "--key_enrichment", dest="key_enrichment", 
                  help="column which have keys in enrichment file", type='int')
parser.add_option("-b", "--value_enrichment", dest="value_enrichment", 
                  help="column which have values in enrichment file", type='int')
parser.add_option("-n", "--name_enrichment", dest="name_enrichment", 
                  help="column which have names in enrichment file", type='int')
parser.add_option("-g", "--genes", dest="genes", 
                  help="column which have genes in enrichment file", type='int')

parser.add_option("-t", "--threshold", dest="threshold", 
                  help="threshold", type='int')
parser.add_option("-e", "--enrichment_type", dest="enrichment_type", 
                  help="column which have values in diseases file", type='str')


parser.add_option("-d", "--diseases_file", dest="diseases_file", 
                  help="file with all data about diseases", metavar="FILE")
parser.add_option("-F", "--key_diseases", dest="key_diseases", 
                  help="column which have keys in diseases file", type='int')
parser.add_option("-f", "--value_diseases", dest="value_diseases", 
                  help="column which have values in diseases file", type='int')


parser.add_option("-i", "--hpo2gene_file", dest="hpo2gene_file", 
                  help="file with all data about hpo2gene", metavar="FILE")
parser.add_option("-K", "--key_hpo2gene", dest="key_hpo2gene", 
                  help="column which have keys in hpo2gene file", type='int')
parser.add_option("-k", "--value_hpo2gene", dest="value_hpo2gene", 
                  help="column which have values in diseases file", type='int')


(options, arg) = parser.parse_args()

#######################################################################################################################################
#														MAIN
#######################################################################################################################################

clusters_hpo_dictionary = fn.build_dictionary(options.cluster_file, options.key_cluster, options.value_cluster)
#print(clusters_hpo_dictionary)

hpo_systems_dictionary = fn.build_dictionary(options.enrichment_file, options.key_enrichment, options.value_enrichment)
#print(hpo_systems_dictionary)

system_name_dictionary = fn.build_dictionary(options.enrichment_file, options.value_enrichment, options.name_enrichment)
#print(system_name_dictionary)

genes_dictionary = fn.build_dictionary(options.diseases_file, options.key_diseases, options.value_diseases)
#print(genes_dictionary)

systems_genes_dictionary = build_dictionary(options.enrichment_file, options.value_enrichment, options.genes, options.enrichment_type, genes_dictionary)
#print(systems_genes_dictionary)

hpo_genes_dictionary = build_hpo2gene_dictionary(options.hpo2gene_file, options.key_hpo2gene, options.value_hpo2gene, genes_dictionary)
#print(hpo_genes_dictionary)


for cluster, HPO_list in clusters_hpo_dictionary.items():
	
	hpo_system_in_cluster_dictionary = dict()
	system_hpo_gene_dictionary = dict()

	for hpo in HPO_list:
		hpo_system_in_cluster_dictionary[hpo] = []

		if hpo in hpo_genes_dictionary:
			hpo_genes = hpo_genes_dictionary[hpo]
			
			#print(hpo, hpo_genes, sep="\t")
		
			if hpo in hpo_systems_dictionary:
				funsys_l = hpo_system_in_cluster_dictionary[hpo]
				funsys_l.extend(hpo_systems_dictionary[hpo])

				for funsys in funsys_l:
					funsys_genes = systems_genes_dictionary[funsys]

					if funsys not in system_hpo_gene_dictionary:
						
						gene_intersection = set.intersection(set(hpo_genes), set(funsys_genes))
						system_hpo_gene_dictionary[funsys] = []
						system_hpo_gene_dictionary[funsys].extend(gene_intersection)
					else:
						gene_intersection1 = set.intersection(set(hpo_genes), set(funsys_genes))
						system_hpo_gene_dictionary[funsys].extend(gene_intersection1)

					#print(cluster, hpo, system_hpo_gene_dictionary, sep="\t")

	#print(cluster, hpo_system_in_cluster_dictionary, sep="\t")
	



	all_hpos = list(hpo_system_in_cluster_dictionary.keys())
	all_systems = list(hpo_system_in_cluster_dictionary.values())
	systems_list = sum(all_systems, [])
	unique_systems = set(systems_list)

	for system in unique_systems:
		times = systems_list.count(system)
		coherence_score = (times * 100) / len(all_hpos)

		if coherence_score >= options.threshold:
			print(cluster, system, "".join(system_name_dictionary[system]), coherence_score, ", ".join(set(system_hpo_gene_dictionary[system])),  sep="\t")
	


