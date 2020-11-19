#! /usr/bin/env bash

module load python/anaconda-3_440
source ~soft_bio_267/initializes/init_R


framework_dir=`dirname $0`
export CODE_PATH=$(readlink -f $framework_dir )
export PATH=$CODE_PATH'/sys_bio_lab_scripts:'$PATH
export PATH=$CODE_PATH'/scripts/py_scripts:'$PATH
export PATH=$CODE_PATH'/scripts/rscripts:'$PATH



current_dir=`pwd`

mkdir external_data
mkdir processed_data
mkdir processed_data/OMIM
mkdir results

																	## DOWNLOAD DATASETS // INPUT FILES

curl https://data.omim.org/downloads/B8yyAwLuSOyA5G3vHOIfIg/mimTitles.txt > external_data/mimTitles.txt
wget http://compbio.charite.de/jenkins/job/hpo.annotations/lastStableBuild/artifact/misc/phenotype_annotation.tab -O external_data/phenotype_annotation.tab
wget http://compbio.charite.de/jenkins/job/hpo.annotations.monthly/159/artifact/annotation/ALL_SOURCES_ALL_FREQUENCIES_diseases_to_genes_to_phenotypes.txt -O external_data/ALL_SOURCES_ALL_FREQUENCIES_diseases_to_genes_to_phenotypes.txt
wget https://raw.githubusercontent.com/obophenotype/human-phenotype-ontology/master/hp.obo -O external_data/hp.obo

cut -f 4,5 external_data/ALL_SOURCES_ALL_FREQUENCIES_diseases_to_genes_to_phenotypes.txt | sort -u > processed_data/hpo_dictionary

																	#GET NEUROMUSCULAR DISEASES OMIM


#INPUT DATA (LIST OF KEYWORDS SEPARATE BY "\n") 
echo -e "MUSCULAR DYSTROPHY\nMYOPATHY\nMYASTHENIC\nMYASTHENIA\nNEUROPATHY\nAMYOTROPHIC LATERAL SCLEROSIS\nSPINAL MUSCULAR ATROPHY\nSPINAL AND BULBAR MUSCULAR ATROPHY\nMYOTONIA\nPERIODIC PARALYSIS\nMYOTONIC DYSTROPHY\nMITOCHONDRIAL CYTOPATHY\nNECROTIZING ENCEPHALOMYELOPATHY\nMITOCHONDRIAL DNA DEPLETION" > external_data/all_diseases_patterns

#Look for OMIM diseases in HPO
grep "OMIM:" external_data/ALL_SOURCES_ALL_FREQUENCIES_diseases_to_genes_to_phenotypes.txt > processed_data/OMIM/OMIM_dictionary
cut -f 1,4 processed_data/OMIM/OMIM_dictionary | sort -u > processed_data/OMIM/omim_disease2phen

echo -e "Total_OMIM_diseases\t`sed -n '/#/!p' external_data/mimTitles.txt | cut -f 2 | sort -u | wc -l`" > results/omim_summary
echo -e "Total_OMIM_diseases_in_HPO\t`cut -f 1 processed_data/OMIM/omim_disease2phen | sort -u | wc -l`" >> results/omim_summary
echo -e "Total_OMIM_phenotypes\t`cut -f 2 processed_data/OMIM/omim_disease2phen | sort -u | wc -l`" >> results/omim_summary
echo -e "Total_OMIM_genes\t`cut -f 2 processed_data/OMIM/OMIM_dictionary | sort -u | wc -l`" >> results/omim_summary
cut -f 2  processed_data/OMIM/OMIM_dictionary | sort -u > processed_data/OMIM/omim_genes

#Look for Neuromuscular Diseases
grep -F -f  external_data/all_diseases_patterns external_data/mimTitles.txt > processed_data/OMIM/all_nmds_list
sort -u processed_data/OMIM/all_nmds_list | sed '/CARDIOMYOPATHY/d' > processed_data/OMIM/uniq_all_nmd_list
echo -e "OMIM_NMD\t`cut -f 2 processed_data/OMIM/uniq_all_nmd_list | sort -u | wc -l`" >> results/omim_summary

parse_diseases.py -d processed_data/OMIM/uniq_all_nmd_list -n external_data/ALL_SOURCES_ALL_FREQUENCIES_diseases_to_genes_to_phenotypes.txt -b 0 -y 3 -t "OMIM" | sort -u > processed_data/OMIM/omim_neuromuscular_disease2phen
number_omim_neuromuscular_diseases=`cut -f 1 processed_data/OMIM/omim_neuromuscular_disease2phen | sort -u | wc -l`

echo -e "Total_OMIM_NMD_in_HPO\t`cut -f 1 processed_data/OMIM/omim_neuromuscular_disease2phen | sort -u | wc -l`" >> results/omim_summary
cut -f 1 processed_data/OMIM/omim_neuromuscular_disease2phen | sort -u > processed_data/OMIM/omim_NMD_list
grep -Fwf processed_data/OMIM/omim_NMD_list processed_data/OMIM/OMIM_dictionary  > processed_data/OMIM/omim_nmd_genes
		
		#Get HPO frequency in Neuromuscular diseases
hpo_frequency.py -i processed_data/OMIM/omim_disease2phen -a 1 -A 0 -n processed_data/hpo_dictionary -B 0 -b 1 | sort -t$'\t' -k3 -rn  > processed_data/OMIM/omim_diseases_hpo_frequency.txt
hpo_frequency.py -i processed_data/OMIM/omim_neuromuscular_disease2phen -a 1 -A 0 -n processed_data/hpo_dictionary -B 0 -b 1 | sort -t$'\t' -k3 -rn  > processed_data/OMIM/neuromuscular_omim_diseases_hpo_frequency.txt

		#Get HPO frequency in Neuromuscular diseases
filter_datasets.py -a processed_data/OMIM/omim_disease2phen -b 0 -x 1 -n processed_data/OMIM/omim_neuromuscular_disease2phen -C 0 -c 1 | sort -u > processed_data/OMIM/omim_non_neuromuscular_disease2phen
number_omim_non_neuromuscular_diseases=`cut -f 1 processed_data/OMIM/omim_non_neuromuscular_disease2phen | sort -u | wc -l`
hpo_frequency.py -i processed_data/OMIM/omim_non_neuromuscular_disease2phen -a 1 -A 0 -n processed_data/hpo_dictionary -B 0 -b 1 | sort -t$'\t' -k3 -rn  > processed_data/OMIM/non_neuromuscular_omim_diseases_hpo_frequency.txt

	#Obtain a phenotype frequency table
get_frequency_table.py -a processed_data/OMIM/omim_diseases_hpo_frequency.txt -B 0 -b 2 -x 1 -y processed_data/OMIM/non_neuromuscular_omim_diseases_hpo_frequency.txt  -n processed_data/OMIM/neuromuscular_omim_diseases_hpo_frequency.txt -C 0 -c 2 > processed_data/OMIM/hpo_frequency_table


get_fisher_chisq.R -i processed_data/OMIM/hpo_frequency_table -n $number_omim_neuromuscular_diseases -d $number_omim_non_neuromuscular_diseases -o processed_data/OMIM/fisher_chisq_omim_hpo_results
cut -f 1,2,5 processed_data/OMIM/fisher_chisq_omim_hpo_results > processed_data/OMIM/fisher_less_omim_hpo
filter_by_value.py -i processed_data/OMIM/fisher_less_omim_hpo -c 2 -t 0.05 -f "less or equal than" > processed_data/OMIM/significant_omim_neuromuscular_hpo
cut -f 1 processed_data/OMIM/significant_omim_neuromuscular_hpo > processed_data/OMIM/list_significant_omim_neuromuscular_hpo
echo -e "Total_OMIM_neuromuscular_phenotypes\t`cut -f 1 processed_data/OMIM/list_significant_omim_neuromuscular_hpo | sort -u | wc -l`" >> results/omim_summary


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


neuro_freq=$current_dir'/processed_data/OMIM/neuromuscular_omim_diseases_hpo_frequency.txt'
non_neuro_freq=$current_dir'/processed_data/OMIM/non_neuromuscular_omim_diseases_hpo_frequency.txt'




#OUTPUT

mkdir PATH/TO/OUTPUT/FILES/neuromuscular_diseases_project
mkdir PATH/TO/OUTPUT/FILES/neuromuscular_diseases_project/build_networks
mkdir PATH/TO/OUTPUT/FILES/neuromuscular_diseases_project/build_networks/OMIM


#AUTOFLOW VARIABLES

#\\$p_values=0.05/0.001/0.00001,

source ~soft_bio_267/initializes/init_autoflow

variables=`echo -e "
	\\$database=OMIM,
	\\$disease2phen=$current_dir'/processed_data/OMIM/omim_disease2phen',
	\\$list_neuromuscular_hpo=$current_dir'/processed_data/OMIM/list_significant_omim_neuromuscular_hpo',
	\\$metric_type=hypergeometric,
	\\$association_thresold=2,
	\\$disease_dictionary=$current_dir'/external_data/ALL_SOURCES_ALL_FREQUENCIES_diseases_to_genes_to_phenotypes.txt',
	\\$dictionary=$current_dir'/processed_data/OMIM/OMIM_dictionary',
	\\$p_values=0.050.05/0.001/0.00001,
	\\$number_of_random_models=100,
	\\$neuro_freq=$neuro_freq,
	\\$non_neuro_freq=$non_neuro_freq,
	\\$current_dir=$current_dir,
	

" | tr -d [:space:]`

AutoFlow -w build_networks.af -o PATH/TO/OUTPUT/FILES/neuromuscular_diseases_project/build_networks/OMIM -V $variables -m 2gb $1 -n cal -t '10:00:00'
#AutoFlow -w build_networks.af -o PATH/TO/OUTPUT/FILES/neuromuscular_diseases_project/build_networks/OMIM -V $variables -m 8gb $1 -n cal -t '10:00:00'
