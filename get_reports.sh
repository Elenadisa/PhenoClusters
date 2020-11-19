#! /usr/bin/env bash
#SBATCH --cpu=1
#SBATCH --mem=4gb
#SBATCH --time=1-00:00:00
#SBATCH --error=job.%J.err
#SBATCH --output=job.%J.out

source ~soft_bio_267/initializes/init_R

current_dir=`pwd`

framework_dir=`dirname $0`
export CODE_PATH=$(readlink -f $framework_dir )
export PATH=$CODE_PATH'/sys_bio_lab_scripts:'$PATH
export PATH=$CODE_PATH'/scripts/py_scripts:'$PATH
export PATH=$CODE_PATH'/scripts/rscripts:'$PATH

mkdir results



omim_build_results_source=PATH/TO/OUTPUT/FILES/neuromuscular_diseases_project/build_networks/OMIM
omim_analysed_results_source=PATH/TO/OUTPUT/FILES/neuromuscular_diseases_project/omim_analysed_networks

orphanet_build_results_source=/PATH/TO/OUTPUT/FILES//neuromuscular_diseases_project/build_networks/Orphanet
orphanet_analysed_results_source=PATH/TO/OUTPUT/FILES/neuromuscular_diseases_project/orphanet_analysed_networks

																## OMIM Results

#Clusters Results
cat $omim_build_results_source/pairs_metrics > results/omim_pairs_table
cat $omim_build_results_source/metrics > results/omim_metrics
cat $omim_analysed_results_source/*/metrics >> results/omim_metrics
cat $omim_build_results_source/gene_metrics > results/omim_gene_table

create_metric_table.rb results/omim_metrics 'Name,Type' results/omim_table_metrics.txt

#Phen-KEGG comention results
cat $omim_analysed_results_source/comention/kegg/*/comention_metrics > results/kegg/omim_kegg_comention_metrics 
create_metric_table.rb results/kegg/omim_kegg_comention_metrics 'Name,Type' results/kegg/omim_kegg_comention_table_metrics.txt

#Phen-GO comention results
cat $omim_analysed_results_source/comention/go/*/comention_metrics > results/go/omim_go_comention_metrics 
create_metric_table.rb results/go/omim_go_comention_metrics 'Name,Type' results/go/omim_go_comention_table_metrics.txt

#Phen-Reactome comention results
cat $omim_analysed_results_source/comention/reactome/*/comention_metrics > results/reactome/omim_reactome_comention_metrics 
create_metric_table.rb results/reactome/omim_reactome_comention_metrics 'Name,Type' results/reactome/omim_reactome_comention_table_metrics.txt


#Create reports
create_report.R -t reports_templates/omim_report_template.Rmd -o results/omim_report.html -d results/omim_table_metrics.txt -H t
create_report.R -t reports_templates/omim_clusters_report_template.Rmd -o results/omim_clusters_details.html -d results/omim_table_metrics.txt -H t
																	


																	#Orphanet Results
#Clusters Results
cat $orphanet_build_results_source/pairs_metrics > results/orphanet_pairs_table
cat $orphanet_build_results_source/metrics > results/orphanet_metrics
cat $orphanet_analysed_results_source/*/metrics >> results/orphanet_metrics
cat $orphanet_build_results_source/gene_metrics > results/orphanet_gene_table

create_metric_table.rb results/orphanet_metrics 'Name,Type' results/orphanet_table_metrics.txt


#Phen-KEGG cometion results
cat $orphanet_analysed_results_source'/comention/kegg/*/comention_metrics' > results/kegg/orphanet_kegg_comention_metrics 
create_metric_table.rb results/kegg/orphanet_kegg_comention_metrics 'Name,Type' results/kegg/orphanet_kegg_comention_table_metrics.txt

#Phen-GO comention results
cat $orphanet_analysed_results_source/comention/go/*/comention_metrics > results/go/orphanet_go_comention_metrics 
create_metric_table.rb results/go/orphanet_go_comention_metrics 'Name,Type' results/go/orphanet_go_comention_table_metrics.txt

#mkdir results/reactome
cat $orphanet_analysed_results_source/comention/reactome/*/comention_metrics > results/reactome/orphanet_reactome_comention_metrics 
create_metric_table.rb results/reactome/orphanet_reactome_comention_metrics 'Name,Type' results/reactome/orphanet_reactome_comention_table_metrics.txt

#Create reports
create_report.R -t reports_templates/orphanet_report_template.Rmd -o results/orphanet_report.html -d results/orphanet_table_metrics.txt -H t
create_report.R -t reports_templates/orphanet_clusters_report_template.Rmd -o results/orphanet_clusters_details.html -d results/orphanet_table_metrics.txt -H t

