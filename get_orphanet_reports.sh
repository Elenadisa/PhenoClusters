#! /usr/bin/env bash
#SBATCH --cpu=1
#SBATCH --mem=4gb
#SBATCH --time=1-00:00:00
#SBATCH --error=job.%J.err
#SBATCH --output=job.%J.out

#LOAD R and ruby
module load  R/4.0.2
module load ruby/2.3.8

current_dir=`pwd`

export PATH=$current_dir'/scripts/ruby_scripts:'$PATH
export PATH=$current_dir'/scripts/py_scripts:'$PATH
export PATH=$current_dir'/scripts/rscripts:'$PATH

mkdir results


orphanet_build_results_source=/PATH/TO/OUTPUT/FILES//neuromuscular_diseases_project/build_networks/Orphanet
orphanet_analysed_results_source=PATH/TO/OUTPUT/FILES/neuromuscular_diseases_project/orphanet_analysed_networks


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



