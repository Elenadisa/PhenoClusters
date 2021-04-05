#! /usr/bin/env bash
module load python/anaconda-4.7.12

#Get tissue data
curl https://www.proteinatlas.org/download/normal_tissue.tsv.zip > normal_tissue.tsv.zip
unzip normal_tissue.tsv.zip

#OMIM
nmd_omim=PATH_TO_OUTPUT_FILES/PhenoClusters/build_networks_def/cut_0000/test/nmd_phen2gene_HyI_2.txt
HyI_omim=PATH_TO_OUTPUT_FILES/PhenoClusters/build_networks_def/cut_0000/test/phen2gene_HyI_2.txt
dict_omim=PATH_TO_OUTPUT_FILES/PhenoClusters/processed_data/OMIM/OMIM_dictionary

./get_fisher_tissue.py -t normal_tissue.tsv -d $dict_omim -n $nmd_omim -a $HyI_omim -i omim_tissues_interest_python.tsv -o omim_tissues_noninterest_python.tsv > omim_genes_summary.txt


#ORPHANET
nmd_orphanet=PATH_TO_OUTPUT_FILES/PhenoClusters/build_networks_def/cut_0001/test/nmd_phen2gene_HyI_2.txt
HyI_orphanet=PATH_TO_OUTPUT_FILES/PhenoClusters/build_networks_def/cut_0001/test/phen2gene_HyI_2.txt
dict_orphanet=PATH_TO_OUTPUT_FILES/PhenoClusters/processed_data/Orphanet/orphanet_dictionary

./get_fisher_tissue.py -t normal_tissue.tsv -d $dict_orphanet -n $nmd_orphanet -a $HyI_orphanet -i orphanet_tissues_interest_python.tsv -o orphanet_tissues_noninterest_python.tsv > orphanet_genes_summary.txt
