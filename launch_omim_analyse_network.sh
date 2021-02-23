#! /usr/bin/env bash



current_dir=`pwd`


export PATH=$current_dir'/scripts/py_scripts:'$PATH
export PATH=$current_dir'/scripts/rscripts:'$PATH
export PATH=$current_dir'/scripts/ruby_scripts:'$PATH

#PATH TO build_networks.sh RESULTS
data_source=PATH_TO_OUTPUT_FILES/PhenoClusters/build_networks/OMIM

#PATH TO DIRECTORY WITH PAIRS LISTS
networks_source=$data_source"/ln_0000/working_networks"

#PATH TO ENRICHMENT RESULTS
enrichment_files=$data_source"/ln_0001/enrichments"

#PATH TO PHENOTYPE PUBMED SEARCH
HPO2pubmed=$current_dir'/processed_data/HPO2pubmed'

#OTHER FILES PATH
all_diseases_data=$current_dir'/external_data/ALL_SOURCES_ALL_FREQUENCIES_diseases_to_genes_to_phenotypes.txt'
hpo_dictionary=$current_dir'/processed_data/hpo_dictionary'
phen2gene=$data_source'/cut_0000/test/phen2gene_HyI_2.txt'



ls $networks_source > omim_working_nets

## PATH TO THE DIRECTORY WHERE TO SAVE THE RESULTS
mkdir PATH_TO_OUTPUT_FILES/PhenoClusters/analysed_networks
mkdir PATH_TO_OUTPUT_FILES/PhenoClusters/analysed_networks/OMIM



																			#LOAD AUTOFLOW
#CLUSTER COHERENT ANALYSIS
#source ~PATH/TO/init_autoflow

# PREPARE VARIABLES NEEDED IN analyse_networks.af
#\\$p_values=0.05/0.001/0.00001,
while read NETWORK
do
	variables=`echo -e "
		\\$working_net=$networks_source/$NETWORK,
		\\$current_dir=$current_dir,
		\\$hpo_dictionary=$hpo_dictionary,
		\\$single_enrichments=$enrichment_files,
		\\$p_values=0.05/0.001/0.00001,
		\\$database=OMIM,
		\\$all_diseases_data=$all_diseases_data,
		\\$HPO2pubmed=$HPO2pubmed,
		\\$current_dir=$current_dir,
		\\$phen2gene$phen2gene,

	" | tr -d [:space:]`
	
	#FOR SLURM SYSTEM
	#AutoFlow -w analyse_networks.af -o PATH_TO_OUTPUT_FILES/PhenoClusters/analysed_networks/OMIM/$NETWORK -V $variables $1 -m 2gb -t '7-00:00:00' -n 'cal'
	#FOR LOCAL UNIX
	#AutoFlow -w analyse_networks.af -o PATH_TO_OUTPUT_FILES/PhenoClusters/analysed_networks/OMIM/$NETWORK -V $variables $1 -b
	
done < omim_working_nets


#PHENOTYPE-FUNCTION PUBMED COMENTION ANALYSIS


kegg_funsys=$data_source'/enrich_by_onto.R_0000/enrich_kegg_single_0.05'
go_funsys=$data_source'/enrich_by_onto.R_0001/enrich_go_single_0.05'
reactome_funsys=$data_source'/enrich_by_onto.R_0002/enrich_reactome_single_0.05'

awk -F"\t" '{print $3"\t"$2}' $kegg_funsys | sort -u > processed_data/OMIM/kegg_omim_nmd_funsys
awk -F"\t" '{print $3"\t"$2}' $go_funsys | sort -u > processed_data/OMIM/go_omim_nmd_funsys
awk -F"\t" '{print $3"\t"$2}' $reactome_funsys | sort -u > processed_data/OMIM/reactome_omim_nmd_funsys


mkdir PATH_TO_OUTPUT_FILES/PhenoClusters/analysed_networks/OMIM/comention
mkdir PATH_TO_OUTPUT_FILES/PhenoClusters/analysed_networks/OMIM/comention/kegg
mkdir PATH_TO_OUTPUT_FILES/PhenoClusters/analysed_networks/OMIM/comention/go
mkdir PATH_TO_OUTPUT_FILES/PhenoClusters/analysed_networks/OMIM/comention/reactome



							#KEGG

#pubmed search
module unload libyaml
module unload openssl
module purge

rm processed.temp processed_data/OMIM/KEGG2pubmed processed_data/failed_queries
pubmedIdRetriever.rb processed_data/OMIM/kegg_omim_nmd_funsys >> processed_data/OMIM/KEGG2pubmed 2> processed_data/failed_queries


kegg_source=$data_source'/enrich_by_onto.R_0000/rdm/0.05'
kegg2pubmed=$current_dir'/processed_data/OMIM/KEGG2pubmed'
ls $kegg_source > omim_kegg_relationships

#Comention analysis
while read NETWORK
do
	variables=`echo -e "
		\\$working_net=$kegg_source/$NETWORK,
		\\$HPO2pubmed=$HPO2pubmed,
		\\$funsys2pubmed=$kegg2pubmed,
		\\$analysis=kegg,


	" | tr -d [:space:]`
	
	#FOR SLURM SYSTEM
	#AutoFlow -w comention_analysis.af -o PATH_TO_OUTPUT_FILES/PhenoClusters/analysed_networks/OMIM/comention/kegg/$NETWORK -V $variables $1 -m 2gb -t '7-00:00:00' -n 'cal'
	#FOR LOCAL UNIX
	#AutoFlow -w comention_analysis.af -o PATH_TO_OUTPUT_FILES/PhenoClusters/analysed_networks/OMIM/comention/kegg/$NETWORK -V $variables $1 -b
	
done < omim_kegg_relationships



						# GO

#Pubmed search 
rm processed.temp processed_data/OMIM/GO2pubmed processed_data/failed_queries
pubmedIdRetriever.rb processed_data/OMIM/go_omim_nmd_funsys >> processed_data/OMIM/GO2pubmed 2> processed_data/failed_queries

go_source=$data_source'/enrich_by_onto.R_0001/rdm/0.05'
go2pubmed=$current_dir'/processed_data/OMIM/GO2pubmed'
ls $go_source > omim_go_relationships

#Comention analysis
while read NETWORK
do
	variables=`echo -e "
		\\$working_net=$go_source/$NETWORK,
		\\$HPO2pubmed=$HPO2pubmed,
		\\$funsys2pubmed=$go2pubmed,
		\\$analysis=go,
		
	" | tr -d [:space:]`
	
	#FOR SLURM SYSTEM
	#AutoFlow -w comention_analysis.af -o PATH_TO_OUTPUT_FILES/PhenoClusters/analysed_networks/OMIM/comention/go/$NETWORK -V $variables $1 -m 2gb -t '7-00:00:00' -n 'cal'
	#FOR LOCAL UNIX
	#AutoFlow -w comention_analysis.af -o PATH_TO_OUTPUT_FILES/PhenoClusters/analysed_networks/OMIM/comention/go/$NETWORK -V $variables $1 -b
	
done < omim_go_relationships



					#Reactome

#Pubmed search
rm processed.temp processed_data/OMIM/Reactome2pubmed processed_data/failed_queries
pubmedIdRetriever.rb processed_data/OMIM/reactome_omim_nmd_funsys >> processed_data/OMIM/Reactome2pubmed 2> processed_data/failed_queries

reactome_source=$data_source'/enrich_by_onto.R_0002/rdm/0.05'
ls $reactome_source > omim_reactome_relationships
reactome2pubmed=$current_dir'/processed_data/OMIM/Reactome2pubmed'

#Comention analysis
while read NETWORK
do
	variables=`echo -e "
		\\$working_net=$reactome_source/$NETWORK,
		\\$HPO2pubmed=$HPO2pubmed,
		\\$funsys2pubmed=$reactome2pubmed,
		\\$analysis=reactome,

	" | tr -d [:space:]`
	
	#FOR SLURM SYSTEM
	#AutoFlow -w comention_analysis.af -o PATH_TO_OUTPUT_FILES/PhenoClusters/analysed_networks/OMIM/comention/reactome/$NETWORK -V $variables $1 -m 2gb -t '7-00:00:00' -n 'cal'
	#FOR LOCAL UNIX
	#AutoFlow -w comention_analysis.af -o PATH_TO_OUTPUT_FILES/PhenoClusters/analysed_networks/OMIM/comention/reactome/$NETWORK -V $variables $1 -b
done < omim_reactome_relationships