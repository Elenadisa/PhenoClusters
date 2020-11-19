# PhenoClusters Version 1.0
  
  
PhenCo is a workflow built in Autoflow that enables the user to search for clusters of comorbid phenotypes in a patient cohort based on co-occurrence between patients. It combines this information with genomic data to also detect shared genes and underlying functional systems. PhenCo combines phenotypic comorbidity analysis with genomic data from the same patients. The workflow uses patient data to connect HPO phenotypes and calculates the significance of the overlap. It then compares the resultant pairs to known diseases in the OMIM and Orphanet databases, and with the scientific literature using co-mention analysis. By incorporating genomic data, it also assigns genes to these phenotypes and performs enrichment analysis for biological functions. Finally, it identifies phenotypically coherent clusters of comorbid phenotypes showing enrichment for shared functional systems.
  
## Systems Requirements
  
Python 3.  
Ruby 2.4.1.  
R version 3.3.1 or higher.  
Bioconductor 3.4 or higher.  
R Markdown.  

### Installation in Linux

**I** Clone this repository. Ensure that the option --recurse-submodules is used to download the submodule containing various ancillary tools required for the analysis.

``
git clone https://github.com/Elenadisa/PhenCo --recurse-submodules
``

**II** Install [Ruby](https://rvm.io/) We recommend using the RVM manager.  

**III** Install the ruby gems [AutoFlow](https://github.com/seoanezonjic/autoflow), [NetAnalyzer](https://github.com/ElenaRojano/NetAnalyzer) and PETS the following code:

``
gem install Autoflow
gem install NetAnalyzer
gem install PETS
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

**VI** Instal [R](https://cloud.r-project.org/). The following R packages must also be installed:  

``
install.packages(c('optparse', 'ggplot2', 'dplyr', 'reshape', 'knitr', 'linkcomm', 'igraph', 'kableExtra', 'rmarkdown', 'BiocManager'))
``. 

Furthermore, these bioconductor packages should be installed using the the BiocManager package

``
BiocManager::install(c("clusterProfiler", "ReactomePA", "org.Hs.eg.db", "DOSE"))
`` 

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
**I** ./launch_*_build_networks.sh.   
**II** ./launch_*_analyse_networks.sh.   
**III** ./get_reports.sh.   


## Citation