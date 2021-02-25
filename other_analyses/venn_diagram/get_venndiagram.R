#! /usr/bin/env Rscript

#@author Elena D. Díaz Santiago
#@Description This script generate a Venn Diagram in a .png new file. 
#To print the diagram instead of generate a new file please comment the line "filename = opt$output" and uncomment the line "grid.draw(venn_plot)"

###################################################################################################################################
#                                            LIBRARIES                                                                              #
###################################################################################################################################

require(VennDiagram)
require(optparse)

###################################################################################################################################
#                                            OPTPARSE                                                                             #
###################################################################################################################################
option_list <- list(
  make_option(c("-i", "--input1"), type="character",
              help="Dataframe with results 1"),
  make_option(c("-I", "--input2"), type="character",
              help="Dataframe with results 2"),
  make_option(c("-c", "--column1"), type="numeric",
              help="Column with the elements to compare 1"),
  make_option(c("-C", "--column2"), type="numeric",
              help="Column with the elements to compare 2"),
  make_option(c("-t", "--Title"), type="character",
              help="Main title"),
  make_option(c("-o", "--output"), type="character",
  				help="output file name")
)

opt <- parse_args(OptionParser(option_list=option_list))


##################################################################################################################################
#													METHODS																		#
#################################################################################################################################


#Load dataframes
df1 <- read.table(opt$input1, sep="\t", stringsAsFactors = FALSE, header = FALSE, quote = "")
df2 <- read.table(opt$input2, sep="\t", stringsAsFactors = FALSE, header = FALSE, quote = "")

#get data to compare
lst1 <- unique(df1[,opt$column1])
lst2 <- unique(df2[,opt$column2])

#Set names to the lists to create the venn diagram
venn.list <- list(OMIM = lst1, 
                  Orphanet = lst2)

#set colors
mycol <- c("#440154ff", '#21908dff')

#Venn diagram
venn_plot <- venn.diagram(venn.list, 
                    filename = opt$output,
                    intersections = TRUE,
                    imagetype = "png",
                    #Title
                    main= opt$title,
                    main.fontface = "bold",
                    main.cex = 1.5,
                    #circles
                    col = mycol,
                    fill = mycol,
                    alpha = 0.5,
                    cex = 2,
                    #Names
                    cat.default.pos = "outer",
                    cat.fontface = "bold",
                    cat.cex = 1,
                    cat.col = mycol )
#grid.draw(venn_plot)
