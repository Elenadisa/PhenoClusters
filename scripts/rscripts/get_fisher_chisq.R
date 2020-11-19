#! /usr/bin/env Rscript

###################################################################################################################################
#                                            LIBRARIES                                                                              #
###################################################################################################################################
require(optparse)


###################################################################################################################################
#                                            OPTPARSE                                                                             #
###################################################################################################################################
option_list <- list(
  make_option(c("-i", "--input"), type="character",
              help="Results table"),
  
  make_option(c("-n", "--neuromuscular_diseases"), type="numeric",
  				help="neuromuscular diseases number"),
  
  make_option(c("-d", "--non_neuromuscular_diseases"), type="numeric",
  				help="non neuromuscular diseases number"),
  
  make_option(c("-o", "--output"), type="character",
  				help="output file name")
)

opt <- parse_args(OptionParser(option_list=option_list))


##################################################################################################################################
#													METHODS																		#
#################################################################################################################################
#load frequency table
frequency_df <- read.table(opt$input, sep="\t", header = FALSE, stringsAsFactors = FALSE, quote = "")
colnames(frequency_df) <- c("HPO", "Name", "N-non_neuromuscular", "N-neuromuscular")

#load number of diseases
neuromuscular_diseases = opt$neuromuscular_diseases
non_neuromuscular_disases = opt$non_neuromuscular_diseases

#create new df
test_df <- data.frame("HPO"=frequency_df$HPO, "HPO_name"=frequency_df$Name, "fisher_two-sided_pvalue"=numeric(length = length(frequency_df$HPO)), "fisher_greater_pvalue"=numeric(length = length(frequency_df$HPO)), "fisher_less_pvalue"=numeric(length = length(frequency_df$HPO)), "chisq_pvalue"=numeric(length = length(frequency_df$HPO)))


#i = 273
for (i in 1:length(frequency_df$HPO)){
  #create the matrix
  mt <- rbind(c(frequency_df$`N-non_neuromuscular`[i], frequency_df$`N-neuromuscular`[i]), 
              c(non_neuromuscular_disases - frequency_df$`N-non_neuromuscular`[i], neuromuscular_diseases - frequency_df$`N-neuromuscular`[i]))
  
  #Perform different tests and save the pvalue in ta data frame
  fisher_two_sided <- fisher.test(mt, alternative = "two.sided")
  test_df$fisher_two.sided_pvalue[i] <- paste(fisher_two_sided$p.value )
  
  
  fisher_greater <- fisher.test(mt, alternative = "greater")
  test_df$fisher_greater_pvalue[i] <- paste(fisher_greater$p.value )
  
  fisher_less <- fisher.test(mt, alternative = "less")
  test_df$fisher_less_pvalue[i] <- paste(fisher_less$p.value )
  
  chisq <- chisq.test(mt)
  test_df$chisq_pvalue[i] <- paste(chisq$p.value )
  }

write.table(test_df, opt$output, sep="\t", col.names = TRUE, row.names = FALSE, quote=FALSE)





