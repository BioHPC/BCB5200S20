# Let’s create a MA plot.
install.packages("ggplot2")
install.packages("cowplot")


library(ballgown)
library(RSkittleBrewer)
library(genefilter)
library(dplyr)
library(devtools)

# change this to the directory that contains all previous results
setwd("~/Google Drive/Teaching/SLU/2018-19/BCB5250_BioinformaticsII/Labs/Lab5/new_tuxedo")

# load the sample information
pheno_data <- read.csv("chrX_data/geuvadis_phenodata.csv")

# create a ballgown object
bg_chrX <- ballgown(dataDir = "ballgown",
                    samplePattern = "ERR",
                    pData = pheno_data)

class(bg_chrX)

bg_chrX

head(gexpr(bg_chrX), 2)
head(texpr(bg_chrX), 2)

# Next we filter out transcripts with low variance.
bg_chrX_filt <- subset(bg_chrX, "rowVars(texpr(bg_chrX)) >1", genomesubset=TRUE)
bg_chrX_filt

head(pData(bg_chrX_filt), 3)

# test on transcripts
results_transcripts <- stattest(bg_chrX_filt,
                                feature="transcript",
                                covariate="sex",
                                adjustvars = c("population"),
                                getFC=TRUE, meas="FPKM")

# results are in a data frame
class(results_transcripts)
dim(results_transcripts)

head(results_transcripts)

table(results_transcripts$qval < 0.05)


# test on genes
results_genes <- stattest(bg_chrX_filt,
                          feature="gene",
                          covariate="sex",
                          adjustvars = c("population"),
                          getFC=TRUE, meas="FPKM")

class(results_genes)
dim(results_genes)
table(results_genes$qval<0.05)


# the order is the same so we can simply combine the information
results_transcripts <- data.frame(geneNames = geneNames(bg_chrX_filt),
                                  geneIDs = geneIDs(bg_chrX_filt),
                                  results_transcripts)

# now we have the identifiers
head(results_transcripts)

# Sort the results from the smallest P value to the largest:
results_transcripts = arrange(results_transcripts,pval)
head(results_transcripts)

results_genes = arrange(results_genes,pval)
head(results_transcripts)

# Write the results to a csv file that can be shared and distributed:
write.csv(results_transcripts, "chrX_transcript_results.csv", row.names=FALSE)
write.csv(results_genes, "chrX_gene_results.csv", row.names=FALSE)

# Identify transcripts and genes with a q value <0.05:
subset(results_transcripts,results_transcripts$qval<0.05)
subset(results_genes,results_genes$qval<0.05)



library(ggplot2)
library(cowplot)

results_transcripts$mean <- rowMeans(texpr(bg_chrX_filt))

ggplot(results_transcripts, aes(log2(mean), log2(fc), colour = qval<0.05)) +
  scale_color_manual(values=c("#999999", "#FF0000")) +
  geom_point() +
  geom_hline(yintercept=0)
