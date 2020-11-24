# PhenoClusters Version 1.0
  
  
PhenoCluster is a workflow built in Autoflow that enables the user to search for clusters of co-occurrent phenotypes diseases. It combines this phenotypic and genetic data to also detect shared genes and underlying functional systems. The workflow uses diseases data to connect HPO phenotypes and calculates the significance of the overlap. It then compares the resultant pairs with scientific literature using co-mention analysis. By incorporating genetic data, it also assigns genes to these phenotypes and performs enrichment analysis for biological functions. Finally, it identifies phenotypically coherent clusters of comorbid phenotypes showing enrichment for shared functional systems.
  
## Systems Requirements
  
Python 3.  
Ruby 2.4.1.  
R version 3.3.1 or higher.  
Bioconductor 3.4 or higher.  
R Markdown.  

### Installation in Linux

**I** Clone this repository. Ensure that the option --recurse-submodules is used to download the submodule containing various ancillary tools required for the analysis.

``
git clone https://github.com/Elenadisa/PhenoClusters --recurse-submodules
``

**II** Install [Ruby](https://rvm.io/) We recommend using the RVM manager.  

**III** Install the ruby gems [AutoFlow](https://github.com/seoanezonjic/autoflow) and [NetAnalyzer](https://github.com/ElenaRojano/NetAnalyzer) with the following code:

``
gem install Autoflow
gem install NetAnalyzer
``

**V** Install [Python 3](https://www.python.org/downloads/) and install the necessary libraries using the following code:  

``
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py   
``.   
``
python3 get-pip.py   
``.   
``
pip3 install optparse-pretty numpy os.path2
``    
  
[Anaconda](https://docs.anaconda.com/anaconda/install/linux/) for python 3.6 can be used instead.
  

**VI** Instal [R](https://cloud.r-project.org/). The following R packages must also be installed:  

``
install.packages(c('optparse', 'ggplot2', 'dplyr', 'reshape', 'knitr', 'linkcomm', 'igraph', 'kableExtra', 'rmarkdown', 'BiocManager', 'HPOSim', 'HPO.db'))
``. 

Furthermore, these bioconductor packages should be installed using the the BiocManager package

``
BiocManager::install(c("clusterProfiler", "ReactomePA", "org.Hs.eg.db", "DOSE", "GO.db", "GOSim"))
`` 
  
## Additional Scripts  
  
PhenoClusters workflow uses some scripts from [sys_bio_lab](https://github.com/seoanezonjic/sys_bio_lab_scripts/tree/65d5dfd061e624f57f7a48b59af997c50e6b6a27). Please download the scripts to run the following sections:

***Pubmed Comention Analysis:***  
get_table_ontology.rb (store in scripts/ruby_scripts)  
pubmedIdRetriever.rb (store in scripts/ruby_scripts)  
get_fisher.R (store in scripts/rscripts)  
***Functional assignment:***  
enrich_by_onto.R (store in scripts/rscripts)  
enrich_by_onto directory (store in scripts/rscripts)  
***Get reports:***  
create_metric_table.rb (store in scripts/ruby_scripts)  
create_report.R (store in scripts/rscripts)  
  

## Usage
  
PhenoClusters workflow consists in five scripts:    
**I.a lauch_omim_build_networks.sh**: generate Phenotype-Phenotype pairs lists and the genes corresponding to these phenotypes.    
**I.b lauch_orphanet_build_networks.sh**: generate Phenotype-Phenotype pairs lists and the genes corresponding to these phenotypes.    
They execute an autoflow template *build_networks.af*.   

**II.a launch_omim_analayse_network.sh**: perform phenotype cluster analysis.   
**II.b launch_orphanet_analayse_network.sh**: perform phenotype cluster analysis.   
They execute an autoflow template *analyse_network.af*.   

**II get_reports.sh**: generates html reports with workflow results.

### Defining input/output paths. 

User have to define input/output paths in launch scripts:  

**I.a launch_omim_build_networks.sh**.   

*Output*.   
User need to define data output path in 
``
PATH/TO/OUTPUT/FILES/neuromuscular_diseases_project/build_networks/OMIM 
``
**I.b launch_orphanet_build_networks.sh**.   

*Output*.   
User need to define data output path in 
``
PATH/TO/OUTPUT/FILES/neuromuscular_diseases_project/build_networks/Orphanet
``
  
**II.a launch_omim_analyse_networks.sh**    
*Input*.   
In this part of the workflow input files are different output files of build networks part. Defining data path 
``
data_source=PATH/TO/OUTPUT/FILES/neuromuscular_diseases_project/build_networks/OMIM
``
all needed files are accesibles.  
*Output*.   
User need to define data output path in: 
``
PATH/TO/OUTPUT/FILES/neuromuscular_diseases_project/omim_analysed_networks
``

**II.b launch_orpjanet_analyse_networks.sh**    
*Input*.   
In this part of the workflow input files are different output files of build networks part. Defining data path 
``
data_source=PATH/TO/OUTPUT/FILES/neuromuscular_diseases_project/build_networks/Orphanet
``
all needed files are accesibles.  
*Output*.   
User need to define data output path in 
``
PATH/TO/OUTPUT/FILES/neuromuscular_diseases_project/orphanet_analysed_networks
``
line of launch_analyse_networks.sh. 

**III get_reports.sh**.   
*Input*.   
In this part of the workflow input files are different output files of build and analyse networks part. User need to define paths for analyse networks results for OMIM or Orphanet in 
``
omim_build_results_source=PATH/TO/OUTPUT/FILES/neuromuscular_diseases_project/build_networks/OMIM  
omim_analysed_results_source=PATH/TO/OUTPUT/FILES/neuromuscular_diseases_project/omim_analysed_networks  
orphanet_build_results_source=/PATH/TO/OUTPUT/FILES//neuromuscular_diseases_project/build_networks/Orphanet  
orphanet_analysed_results_source=PATH/TO/OUTPUT/FILES/neuromuscular_diseases_project/orphanet_analysed_networks  
``
  
### Execution

The templetes have to be executed in a certain order.    
**Ia** ./launch_omim_build_networks.sh.	**Ib** ./launch_orphanet_build_networks.sh.   
**IIa** ./launch_omim_analyse_networks.sh.	**IIb** ./launch_orphanet_analyse_networks.sh.   
**IIIa** ./get_omim_reports.sh.	**IIIb**./get_orphanet_reports.sh.   


## Citation