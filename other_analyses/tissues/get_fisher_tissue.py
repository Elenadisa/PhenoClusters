#! /usr/bin/env python

#@Description: script to look for genes expressed in tissues of interest
#@Author Elena D. Díaz Santiago   

#####################################################################################################################################################################
#																				METHODS																				#
#####################################################################################################################################################################
import optparse
import numpy as np
import pandas as pd
import scipy.stats as stats

def build_dictionary(filename):
	file = open(filename)
	gene_dictionary = dict()
	for line in file:
		line.rstrip("\n")
		fields = line.split("\t")

		keycol = fields[2]
		valuecol = fields[1]

		if keycol not in gene_dictionary:
			gene_dictionary[keycol] = valuecol
		else:
			if valuecol not in gene_dictionary[keycol]:
				gene_dictionary[keycol].append(valuecol)
	return gene_dictionary

def search_dictionary(dictionary, lst):
	new_lst = []
	for gene in lst:
		new_lst.append(dictionary[str(gene)])
	return new_lst

def get_tissues_data(tissue):
	td = tissue_data.loc[(tissue_data.Tissue == tissue)]
	ts_genes = set(td['Gene name'].to_list())
	nmd_genes_i = len(ts_genes.intersection(nmd_genes))
	nmd_genes_ni = len(nmd_genes) - nmd_genes_i
	proportion_nmd = nmd_genes_i / len(nmd_genes)
	all_genes_i = len(ts_genes.intersection(all_genes))
	all_genes_ni = len(all_genes) - all_genes_i
	proportion_all = all_genes_i / len(all_genes)

	contingecy_tb = np.array([[nmd_genes_i, nmd_genes_ni], [all_genes_i, all_genes_ni]])
	oddsratio, pvalue = stats.fisher_exact(contingecy_tb, alternative='greater')


	return [tissue, nmd_genes_i, proportion_nmd, all_genes_i, proportion_all, pvalue]


#####################################################################################################################################################################
#																			OPTPARSE																				#
#####################################################################################################################################################################

import optparse

parser=optparse.OptionParser()

parser.add_option("-t", "--tissue_file", dest="tissue_file", 
                  help="tissue file", metavar="FILE")

parser.add_option("-d", "--dictionary_file", dest="dictionary", 
                  help="gene dictionary file", metavar="FILE")

parser.add_option("-n", "--nmd_genes_file", dest="nmd_genes", 
                  help="nmd genes file", metavar="FILE")

parser.add_option("-a", "--all_genes_file", dest="all_genes", 
                  help="all genes file", metavar="FILE")

parser.add_option("-i", "--interest_tissue_output_file", dest="intereset_ouput", 
                  help="intereset tissue ouput file", metavar="FILE")

parser.add_option("-o", "--noninterest_tissue_output_file", dest="nonintereset_ouput", 
                  help="non intereset tissue ouput file", metavar="FILE")


(options, arg) = parser.parse_args()


#####################################################################################################################################################################
#																			MAIN																					#
#####################################################################################################################################################################

#Filter tissue file by level
tissue_data = pd.read_csv(options.tissue_file, delimiter="\t")
tissue_data = tissue_data.loc[(tissue_data.Level == "High") | (tissue_data.Level == "Medium")]
tissue_data_genes = set(tissue_data['Gene name'].to_list())
#tissue_data.to_csv("test_python", sep="\t")

#Load gene dictionary
gene_dictionary = build_dictionary(options.dictionary)
#print(gene_dictionary)

#Load phen2gene files
nmd_gene_df = pd.read_csv(options.nmd_genes, delimiter="\t", header = None)
all_gene_df = pd.read_csv(options.all_genes, delimiter="\t", header = None)

#Set gene lists, map to gene symbol and get the genes present in tissues df
nmd_genes = set(search_dictionary(gene_dictionary, set(nmd_gene_df[1].to_list())))
nmd_genes = tissue_data_genes.intersection(nmd_genes)
all_genes = set(search_dictionary(gene_dictionary, set(all_gene_df[1].to_list()))) - nmd_genes 
all_genes = tissue_data_genes.intersection(all_genes)

#Get tissues of intereset
tissue_intereset = tissue_data.loc[(tissue_data.Tissue == "cerebellum") | (tissue_data.Tissue == "cerebral cortex") | (tissue_data.Tissue == "hippocampus") | (tissue_data.Tissue == "caudate") | (tissue_data.Tissue == "skeletal muscle") | (tissue_data.Tissue == "heart muscle")]
ti_genes = set(tissue_intereset['Gene name'].to_list())

#Get contingecy table and fisher test
nmd_genes_ti = len(ti_genes.intersection(nmd_genes))
#print("Number of NMD genes expressed in tissues of interest: " , nmd_genes_ti)
#print("Proportion of NMD genes: ", nmd_genes_ti / len(nmd_genes))
nmd_genes_ti_out = len(nmd_genes) - nmd_genes_ti
all_genes_ti = len(ti_genes.intersection(all_genes))
all_genes_ti_out = len(all_genes) - all_genes_ti
#print("Number of non-NMD genes expressed in tissues of intereset: " , all_genes_ti)
#print("Proportion of non-NMD genes: ", all_genes_ti / len(all_genes))
ti_contingecy_tb = np.array([[nmd_genes_ti, nmd_genes_ti_out], [all_genes_ti, all_genes_ti_out]])
ti_contingecy_tb=pd.DataFrame(ti_contingecy_tb, columns=["Expressed", "Not-expressed"])
ti_contingecy_tb.index=["NMD", "non-NMD"]
oddsratio, pvalue = stats.fisher_exact(ti_contingecy_tb, alternative='greater')
#print("Fisher test pvalue: ", pvalue)

#print(ti_contingecy_tb)

#get rest of tissues
tissue_nonintereset = tissue_data[~tissue_data.isin(tissue_intereset)].dropna()
tni_genes = set(tissue_nonintereset['Gene name'].to_list())

#Get Contingency table and fisher test
nmd_genes_tni = len(tni_genes.intersection(nmd_genes))
nmd_genes_tni_out = len(nmd_genes) - nmd_genes_tni
print("Number of NMD genes expressed in other tissues: " , nmd_genes_tni)
print("Proportion of NMD genes: ", nmd_genes_tni / len(nmd_genes))
all_genes_tni = len(tni_genes.intersection(all_genes))
all_genes_tni_out = len(all_genes) - all_genes_tni
print("Number of non-NMD genes expressed in other tissues: " , all_genes_tni)
print("Proportion of non-NMD genes: ", all_genes_tni / len(all_genes))
tni_contingecy_tb = np.array([[nmd_genes_tni, nmd_genes_tni_out], [all_genes_tni, all_genes_tni_out]])
tni_contingecy_tb=pd.DataFrame(tni_contingecy_tb, columns=["Expressed", "Not-expressed"])
tni_contingecy_tb.index=["NMD", "non-NMD"]
oddsratio, pvalue = stats.fisher_exact(tni_contingecy_tb, alternative='greater')
print("Fisher test pvalue: ", pvalue)


#################################################################################################################################################################
#													GET PROPORTION OF EXPRESSED GENES BY EACH TISSUE 																				#
#################################################################################################################################################################

tissue_i = set(tissue_intereset['Tissue'].to_list())
res_i = map(get_tissues_data, tissue_i)
data_i = pd.DataFrame(res_i, columns = ["Tissue", "NMD genes", "NMD genes proportion", "non-NMD genes", "non-NMD genes proportion", "Pvalues"])
data_i.to_csv(options.intereset_ouput, index=False, sep="\t")

tissue_ni = set(tissue_nonintereset['Tissue'].to_list())
res_ni = map(get_tissues_data, tissue_ni)
data_ni = pd.DataFrame(res_i, columns = ["Tissue", "NMD genes", "NMD genes proportion", "non-NMD genes", "non-NMD genes proportion", "Pvalues"])
data_ni.to_csv(options.nonintereset_ouput, index=False, sep="\t")