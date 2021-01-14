#! /usr/bin/env bash

#LOAD R AND PYTHON
module load python/anaconda-3_440
module load R/4.0.2
module load ruby/2.4.1

current_dir=`pwd`

export PATH=$current_dir'/scripts/ruby_scripts:'$PATH
export PATH=$current_dir'/scripts/py_scripts:'$PATH
export PATH=$current_dir'/scripts/rscripts:'$PATH

mkdir external_data
mkdir processed_data
mkdir processed_data/Orphanet
mkdir processed_data/results

																	## DOWNLOAD DATASETS // INPUT FILES

## Generated: 2019-11-15
wget http://compbio.charite.de/jenkins/job/hpo.annotations/lastStableBuild/artifact/misc/phenotype_annotation.tab -O external_data/phenotype_annotation.tab
## Generated: 2019-11-15
wget http://compbio.charite.de/jenkins/job/hpo.annotations.monthly/159/artifact/annotation/ALL_SOURCES_ALL_FREQUENCIES_diseases_to_genes_to_phenotypes.txt -O external_data/ALL_SOURCES_ALL_FREQUENCIES_diseases_to_genes_to_phenotypes.txt
## format-version: 1.2
curl http://data.bioontology.org/ontologies/ORDO_OBO/submissions/1/download?apikey=8b5b7825-538d-40e0-9e9e-5ab9274a9aeb > external_data/orphanet_ordo.obo
## format-version: 1.2
wget https://raw.githubusercontent.com/obophenotype/human-phenotype-ontology/master/hp.obo -O external_data/hp.obo

cut -f 4,5 external_data/ALL_SOURCES_ALL_FREQUENCIES_diseases_to_genes_to_phenotypes.txt | sort -u > processed_data/hpo_dictionary

																			#ORPHANET NEUROMUSCULAR DISEASES

#Look for Orphanet diseases in HPO
grep "ORPHA:" external_data/ALL_SOURCES_ALL_FREQUENCIES_diseases_to_genes_to_phenotypes.txt > processed_data/Orphanet/orphanet_dictionary

cut -f 1,4 processed_data/Orphanet/orphanet_dictionary | sort -u > processed_data/Orphanet/orphanet_disease2phen
hpo_frequency.py -i processed_data/Orphanet/orphanet_disease2phen -a 1 -A 0 -n processed_data/hpo_dictionary -B 0 -b 1 | sort -t$'\t' -k3 -rn  > processed_data/Orphanet/orphanet_diseases_hpo_frequency.txt
echo -e "Total_Orphanet_diseases_in_HPO\t`cut -f 1 processed_data/Orphanet/orphanet_disease2phen | sort -u | wc -l`" >> results/orphanet_summary
echo -e "Total_Orphanet_phenotypes\t`cut -f 2 processed_data/Orphanet/orphanet_disease2phen | sort -u | wc -l`" >> results/orphanet_summary
echo -e "Total_Orphanet_genes\t`cut -f 2 processed_data/Orphanet/orphanet_dictionary | sort -u | wc -l`" >> resultsorphanet_summary
cut -f 2  processed_data/Orphanet/orphanet_dictionary | sort -u > processed_data/Orphanet/orphanet_genes


#Get neuromuscular diseases

get_orphanet_diseases.py -o external_data/orphanet_ordo.obo -s "Orphanet:183497" | sort -u > processed_data/Orphanet/all_orphanet_list_neuromuscular_diseases
echo -e "Total_Orphanet_NMD\t`cut -f 1 processed_data/Orphanet/all_orphanet_list_neuromuscular_diseases | sort -u | wc -l`" >> results/orphanet_summary

parse_diseases.py -d processed_data/Orphanet/orphanet_list_neuromuscular_diseases -n external_data/ALL_SOURCES_ALL_FREQUENCIES_diseases_to_genes_to_phenotypes.txt -b 0 -y 3 -t "ORPHA" | sort -u > processed_data/Orphanet/orphanet_neuromuscular_disease2phen
number_orphanet_neuromuscular_diseases=`cut -f 1 processed_data/Orphanet/orphanet_neuromuscular_disease2phen | sort -u | wc -l`
echo -e "Total_Orphanet_NMD_in_HPO\t`cut -f 1 processed_data/Orphanet/orphanet_neuromuscular_disease2phen | sort -u | wc -l`" >> results/orphanet_summary
cut -f 1 processed_data/Orphanet/orphanet_neuromuscular_disease2phen | sort -u > processed_data/Orphanet/orphanet_NMD_list

hpo_frequency.py -i processed_data/Orphanet/orphanet_neuromuscular_disease2phen -a 1 -A 0 -n processed_data/hpo_dictionary -B 0 -b 1 | sort -t$'\t' -k3 -rn  > processed_data/Orphanet/neuromuscular_orphanet_diseases_hpo_frequency.txt

	#Get Non Neuromuscular diseases frequency
filter_datasets.py -a processed_data/Orphanet/orphanet_disease2phen -b 0 -x 1 -n processed_data/Orphanet/orphanet_neuromuscular_disease2phen -C 0 -c 1 | sort -u > processed_data/Orphanet/orphanet_non_neuromuscular_disease2phen
number_orphanet_non_neuromuscular_diseases=`cut -f 1 processed_data/Orphanet/orphanet_non_neuromuscular_disease2phen | sort -u | wc -l`
hpo_frequency.py -i processed_data/Orphanet/orphanet_non_neuromuscular_disease2phen -a 1 -A 0 -n processed_data/hpo_dictionary -B 0 -b 1 | sort -t$'\t' -k3 -rn  > processed_data/Orphanet/non_neuromuscular_orphanet_diseases_hpo_frequency.txt

	#Get HPO frequency table
get_frequency_table.py -a processed_data/Orphanet/orphanet_diseases_hpo_frequency.txt -B 0 -b 2 -x 1 -y processed_data/Orphanet/non_neuromuscular_orphanet_diseases_hpo_frequency.txt  -n processed_data/Orphanet/neuromuscular_orphanet_diseases_hpo_frequency.txt -C 0 -c 2 > processed_data/Orphanet/hpo_frequency_table


#Get Specific HPO
get_fisher_chisq.R -i processed_data/Orphanet/hpo_frequency_table -n $number_orphanet_neuromuscular_diseases -d $number_orphanet_non_neuromuscular_diseases -o processed_data/Orphanet/fisher_chisq_orphanet_hpo_results
cut -f 1,2,5 processed_data/Orphanet/fisher_chisq_orphanet_hpo_results > processed_data/Orphanet/fisher_less_orphanet_hpo
filter_by_value.py -i processed_data/Orphanet/fisher_less_orphanet_hpo -c 2 -t 0.05 -f "less or equal than" > processed_data/Orphanet/significant_orphanet_neuromuscular_hpo
cut -f 1 processed_data/Orphanet/significant_orphanet_neuromuscular_hpo > processed_data/Orphanet/list_significant_orphanet_neuromuscular_hpo
echo -e "Total_Orphanet_neuromuscular_phenotypes\t`cut -f 1 processed_data/Orphanet/list_significant_orphanet_neuromuscular_hpo | sort -u | wc -l`" >> results/orphanet_summary


																				#HPO-PUBMED IDs

get_table_ontology.rb external_data/hp.obo name,synonym | cut -f 1,2  > processed_data/HPO_table.txt
cut -f 4 external_data/ALL_SOURCES_ALL_FREQUENCIES_diseases_to_genes_to_phenotypes.txt | sort -u > processed_data/relevant_HPO.txt
grep -Fwf processed_data/relevant_HPO.txt processed_data/HPO_table.txt | sort -u > processed_data/name2hpo_table.txt

module unload libyaml
module unload openssl
module purge
rm processed.temp processed_data/HPO2pubmed processed_data/failed_queries
pubmedIdRetriever.rb processed_data/name2hpo_table_1.txt >> processed_data/HPO2pubmed 2> processed_data/failed_queries
module purge



neuro_freq=/mnt/home/users/bio_267_uma/elenads/projects/neuromuscular_diseases1/github/processed_data/Orphanet/neuromuscular_orphanet_diseases_hpo_frequency.txt
non_neuro_freq=/mnt/home/users/bio_267_uma/elenads/projects/neuromuscular_diseases1/github/processed_data/Orphanet/non_neuromuscular_orphanet_diseases_hpo_frequency.txt


#PATH TO THE DIRECTORY WHERE TO SAVE THE RESULTS
mkdir PATH_TO_OUTPUT_FILES/PhenoClusters
mkdir PATH_TO_OUTPUT_FILES/PhenoClusters/build_networks
mkdir PATH_TO_OUTPUT_FILES/PhenoClusters/build_networks/Orphanet



#AUTOFLOW VARIABLES

#\\$p_values=0.05/0.001/0.00001,

# LOAD AUTOFLOW
source ~PATH/TO/init_autoflow

variables=`echo -e "
	\\$database=Orphanet,
	\\$disease2phen=$current_dir'/processed_data/Orphanet/orphanet_disease2phen',
	\\$list_neuromuscular_hpo=$current_dir'/processed_data/Orphanet/list_significant_orphanet_neuromuscular_hpo',
	\\$metric_type=hypergeometric,
	\\$association_thresold=2,
	\\$number_of_random_models=50,
	\\$disease_dictionary=$current_dir'/external_data/ALL_SOURCES_ALL_FREQUENCIES_diseases_to_genes_to_phenotypes.txt',
	\\$dictionary=$current_dir'/processed_data/Orphanet/orphanet_dictionary',
	\\$p_values=0.05/0.001/0.00001,
	\\$number_of_random_models=100,
	\\$neuro_freq=$neuro_freq,
	\\$non_neuro_freq=$non_neuro_freq,	
	\\$current_dir=$current_dir,

" | tr -d [:space:]`

AutoFlow -w build_networks.af -o PATH_TO_OUTPUT_FILES/PhenoClusters/build_networks/Orphanet -V $variables -m 2gb $1 -n cal -t '10:00:00'
#AutoFlow -w build_networks.af -o PATH_TO_OUTPUT_FILES/PhenoClusters/build_networks/Orphanet -V $variables -m 8gb $1 -n cal -t '10:00:00'
