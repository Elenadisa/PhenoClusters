# PhenoClusters Version 1.0
  
  
PhenoCluster is a workflow built in Autoflow that enables the user to search for clusters of co-occurrent phenotypes diseases. It combines this phenotypic and genetic data to also detect shared genes and underlying functional systems. The workflow uses diseases data to connect HPO phenotypes and calculates the significance of the overlap. It then compares the resultant pairs with scientific literature using co-mention analysis. By incorporating genetic data, it also assigns genes to these phenotypes and performs enrichment analysis for biological functions. Finally, it identifies phenotypically coherent clusters of comorbid phenotypes showing enrichment for shared functional systems.
  
## Systems Requirements
  
The flow is programmed into several languages they need. In addition, for each language you will need to install their corresponding bookries (see Installation in Linux section). Finally it will be necessary to download scripts from the group repository [sys_bio_lab](https://github.com/seoanezonjic/sys_bio_lab_scripts/tree/65d5dfd061e624f57f7a48b59af997c50e6b6a27).  
  
### Programming Languages
  
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
  
### Additional Scripts  
  
PhenoClusters workflow uses some scripts from [sys_bio_lab](https://github.com/seoanezonjic/sys_bio_lab_scripts/tree/65d5dfd061e624f57f7a48b59af997c50e6b6a27). Please download the scripts to run the following sections:

***Pubmed Comention Analysis:***  
get_table_ontology.rb (keep it in scripts/ruby_scripts)  
pubmedIdRetriever.rb (keep it in scripts/ruby_scripts)  
get_fisher.R (keep it in scripts/rscripts)  
***Functional assignment:***  
enrich_by_onto.R (keep it in scripts/rscripts)  
enrich_by_onto directory (keep it in scripts/rscripts)  
***Get reports:***  
create_metric_table.rb (keep it in scripts/ruby_scripts)  
create_report.R (keep it in scripts/rscripts)  
  

## Workflow elements  
  
**- Autoflow templates:** There are six main scripts programmed in bash (.sh) with their correspond autoflow template (.af). These scripts are located in the main directory. (1) *lauch_omim_build_networks.sh* to generate phenotype-phenotype pairs from OMIM diseases and the genes corresponding to these phenotypes, while *lauch_orphanet_build_networks.sh* do the same for Orphanet database; (2) *launch_omim_analayse_network.sh* to clusterise OMIM phenotypes and *launch_orphanet_analayse_network.sh* to clusterise Orphanet phenotypes; and (3) *get_omim_report.sh* generates the ready-to-use html graphical report for data from OMIM, while *get_orphanet_reports.sh* do the same for Orphanet results.

**- Scripts:** Script directory contain the script that will be executed allong the workflow. There is a directory for each programming language used (Python (/py_scripts), R (/rscript), ruby (ruby_scripts)).  
**-Report_templates:** Directory which contain RMarkdown report templates to obtain the results of executing different parts of the workflow.  

  
## Usage
  
PhenoClusters workflow consists in six scripts:    
**I.a lauch_omim_build_networks.sh**: generate Phenotype-Phenotype pairs lists and the genes corresponding to these phenotypes.    
**I.b lauch_orphanet_build_networks.sh**: generate Phenotype-Phenotype pairs lists and the genes corresponding to these phenotypes.    
They execute an autoflow template *build_networks.af*.   

**II.a launch_omim_analayse_network.sh**: perform phenotype cluster analysis.   
**II.b launch_orphanet_analayse_network.sh**: perform phenotype cluster analysis.   
They execute an autoflow template *analyse_network.af*.   

**III.a get_omim_reports.sh**: generates html reports with workflow results for OMIM analysis.  
**III.b get_orphanet_reports.sh**: generates html reports with workflow results for Orphanet analysis.  

### Defining input/output paths. 

User have to define input/output paths in launch scripts:  

**I.a launch_omim_build_networks.sh**.   

*Output*.   
User need to define data output path in 
``
PATH_TO_OUTPUT_FILES/PhenoClusters/build_networks/OMIM 
``
**I.b launch_orphanet_build_networks.sh**.   

*Output*.   
User need to define data output path in 
``
PATH_TO_OUTPUT_FILES/PhenoClusters/build_networks/Orphanet
``
  
**II.a launch_omim_analyse_networks.sh**    
*Input*.   
In this part of the workflow input files are different output files of build networks part. Defining data path 
``
data_source=PATH_TO_INPUT_FILES/PhenoClusters/build_networks/OMIM
``
all needed files are accesibles.  
*Output*.   
User need to define data output path in: 
``
PATH_TO_OUTPUT_FILES/PhenoClusters/analysed_networks/OMIM
``

**II.b launch_orpjanet_analyse_networks.sh**    
*Input*.   
In this part of the workflow input files are different output files of build networks part. Defining data path 
``
data_source=PATH_TO_OUTPUT_FILES/Phenoclusters/build_networks/Orphanet
``
all needed files are accesibles.  
*Output*.   
User need to define data output path in 
``
PATH_TO_OUTPUT_FILES/PhenoClusters/analysed_networks/Orphanet
``
line of launch_analyse_networks.sh. 

**III get_reports.sh**.   
*Input*.   
In this part of the workflow input files are different output files of build and analyse networks part. User need to define paths for analyse networks results for OMIM or Orphanet in 
``
omim_build_results_source=PATH_TO_OUTPUT_FILES/PhenoClusters/build_networks/OMIM  
omim_analysed_results_source=PATH_TO_OUTPUT_FILES/PhenoClusters/analysed_networks/OMIM  
orphanet_build_results_source=PATH_TO_OUTPUT_FILES/PhenoClusters/build_networks/Orphanet  
orphanet_analysed_results_source=PATH_TO_OUTPUT_FILES/PhenoClusters/analysed_networks/Orphanet  
``

### Defining Keywords

Keywords are essential to be able to divide diseases into NMDs and not -NMDs. However, these keywords can be modified to adapt the workflow to the study of other diseases.  
**OMIM:** was searched with keywords describing NMDs. At the begining of *lauch_omim_build_networks.sh* script, there is a line where kewords are specified:
  
```
#INPUT DATA (LIST OF KEYWORDS SEPARATE BY "\n") 
echo -e "MUSCULAR DYSTROPHY\nMYOPATHY\nMYASTHENIC\nMYASTHENIA\nNEUROPATHY\nAMYOTROPHIC LATERAL SCLEROSIS\nSPINAL MUSCULAR ATROPHY\nSPINAL AND BULBAR MUSCULAR ATROPHY\nMYOTONIA\nPERIODIC PARALYSIS\nMYOTONIC DYSTROPHY\nMITOCHONDRIAL CYTOPATHY\nNECROTIZING ENCEPHALOMYELOPATHY\nMITOCHONDRIAL DNA DEPLETION" > external_data/all_diseases_patterns
```  
  
If you want to study other diseases you only have to add your keywords in this line separated by "\n".  
  
**Orphanet:** organises diseases based on the ORDO ontology (Vasant et al., 2014) and NMDs can be retrieved using Genetic neuromuscular disease (Orphanet:183497). As ORDO is organized as an acyclic graph we need a script to look for NMDs. This is a part of *lauch_orphanet_build_networks.sh* script:  
  
```
get_orphanet_diseases.py -o external_data/orphanet_ordo.obo -s "Orphanet:183497" | sort -u > processed_data/Orphanet/all_orphanet_list_neuromuscular_diseases
```
  
You can change the term "Orphanet:183497" to the Orphanet term you want to study.  
  
### Make PATH accesible all the installed software.
  
As different programming language are used, the path must be made accessible for all installed software (R, python, Ruby, NetAnalyzer y Autoflow). You'll find in the workflow scripts a comment - LOAD XX in the places where it needs some path to a software.   

### Make PATH accesible the folder scripts.  
  
In scripts directory there are other directorys in which the scripts needed for running the workflow. There are one directory for each programming language.  
Make sure that the path accesible for the scripts directory in the different workflow parts.  
  
  
## Execution

PhenoClusters workflow consists of different scripts that execute Autoflow templates that will serve to extract and analyze information from two different databases, OMIM and Orphanet. These scripts/templates are located in the main directory. Autoflow templates will execute different scripts located in their corresponding directory. 

Autoflow templates have to be executed in a certain order:

**OMIM:**
***Ia*** ./launch_omim_build_networks.sh: generate phenotype-phenotype pairs from OMIM diseases and the genes corresponding to these phenotypes.  
***IIa*** ./launch_omim_analyse_networks.sh: clusterise OMIM phenotypes.      
***IIIa*** ./get_omim_reports.sh: generates the ready-to-use html graphical report for data from OMIM.  

**Orphanet:**  
***Ib*** ./launch_orphanet_build_networks.sh
***IIb*** ./launch_orphanet_analyse_networks.sh.  
***IIIb***./get_orphanet_reports.sh.  
  
## Citation