#! /usr/bin/env bash
#BATCH --cpu=1
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



omim_build_results_source=PATH_TO_OUTPUT_FILES/PhenoClusters/build_networks/OMIM
omim_analysed_results_source=PATH_TO_OUTPUT_FILES/PhenoClusters/analysed_networks/OMIM


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
