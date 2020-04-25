---
layout: page
title: Lab HW #2 (RNA-Seq Analysis)
subtitle: Lab HW #2 (RNA-Seq Analysis) (50 points)
---

### Due
Tue, Apr 28 2020, 11:59 PM

## Choose either Ver 1 (this year new homework) or Ver 2 (last year homework)

## Ver-1

### Homework
RNA-Seq Lab: In previous, we worked RNA-Seq lab with chrX_data.tar.gz dataset. Now I request you to complete this homework using another yeast dataset with steps.

1. The dataset and experiment: RNA-seq Experiments from Calorie Restricted and Non-Restricted WT Yeast
  - Paper and dataset:
    - Paper Link: [http://dx.doi.org/10.1016/j.cmet.2014.04.004](http://dx.doi.org/10.1016/j.cmet.2014.04.004)
    - SGD dataset link: [https://www.yeastgenome.org/dataset/GSE53720](https://www.yeastgenome.org/dataset/GSE53720)
    - GEO ID: [GSE53720](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE53720)
    - This is not a paired-end data set
  - How to download the dataset?
    - Use fasterq-dump that was mentioned at [Lec12](https://biohpc.github.io/BCB5250S20/lectures/BCB5250_Lec12.pdf)
    - I recommend you to download and install [NCBI SRA Toolkit](https://github.com/ncbi/sra-tools) by yourself, but you can try to add below directory into your .bashrc on hopper machine.
      - /public/ahnt/courses/bcb5250/rna_seq_lab/software/sratoolkit.2.10.5-centos_linux64/bin
    - There are 4 samples (SRR1066657 - SRR1066660)
    - Simply, you can download a sample as $ fasterq-dump SRR1066659 
    - This is not a part of homework, but Consider how to download many files. At the bottom, there is "SRA Run Selector" button to list and select runs to be downloaded. Then, you can make your own simple script to loop the sample run IDs. 
2. Quality Contol (FASTQC, MultiQC, Trimmomatic)
  - Check the quality of one data (SRR1066657) file using FASTQC.
  - If Per base sequence quality is passed (green checked mark), do not trim and filter all data samples.
  - If 3 prime end has very low quality sequences, then trim and filter the low quality sequences using Trimmomatic with using a sliding window of size 4 that will remove bases if their phred score is below 20 and also discard any reads that do not have at least 25 bases remaining after this trimming step. 
3. Alignment (STAR)
  - Indexing
    - Download the reference from [link](http://sgd-archive.yeastgenome.org/sequence/S288C_reference/genome_releases/S288C_reference_genome_R64-2-1_20150113.tgz)
    - In the directory, there is a reference genome with a filename S288C_reference_sequence_R64-2-1_20150113.fsa. However, the chromosome names of this genome and gene set (saccharomyces_cerevisiae_R64-2-1_20150113.gff3) do not agree each other. The genome has a format of >ref NC_001133 [org=Saccharomyces cerevisiae] [strain=S288C] [moltype=genomic] [chromosome=I] and the geneset has a format of chrI. 
    - Also, the GFF file has a FASTA sequences attached at the end.
    - So, you can split the FASTA sequences as a reference that has the same format of the chromosome names.
    - If you use the GFF3 to index genome using STAR, you will get error as "Fatal INPUT FILE error, no exon lines ...". This GFF3 format is not compatible with STAR. So, convert the GFF file into GTF, for instance you can use gffread from Cufflinks package to convert gff to gtf: $ gffread -T In.gff3 -o Out.gtf
    - For you, I worked above things and proivde genome ([link](saccharomyces_cerevisiae_R64-2-1_20150113.fasta) and GTF gene set ([link](saccharomyces_cerevisiae_R64-2-1_20150113.gtf)).
    - Because this is a small genome, --genomeSAindexNbases value is good with 10, not default 12.
    - I set --sjdbOverhang 49. Why? Check the manual of STAR and read length of the dataset.
    - For you, I provide the index shell script ([link](STAR_index.sh))
  - Mapping
    - Using default options and parameters is OK. Check the slides or STAR manual.
4. Quantificaiton (featureCounts)
  - Using default options and parameters is OK.
5. Differential Expression analysis (DESeq2, input will be from both by Step 4)
  - I just want you to check the two groups (report any meaningful plot like PCA plot) and report differentially expressed genes by P-value (top 50)
  - [This kind of reference](https://bioinformatics-core-shared-training.github.io/cruk-summer-school-2018/RNASeq2018/html/04_DE_analysis_with_DESeq2.nb.html) will be useful for you, but check the [DESeq2 guide](https://bioc.ism.ac.jp/packages/2.14/bioc/vignettes/DESeq2/inst/doc/beginner.pdf) for any further analysis as you want.
6. Your comments
7. (Optional for +10 points) Run Salmon for quantification and reanlayze the differential expression using DESeq2. Provide the comparision results. 

### Important
Run all Linux commands with shell to keep the commands. Then, provide the shell (or can copy/paste into your document)

### Submit
Submit all docs, scripts, results into one PDF or multiple files (docs, pdf, txt, sh, zip, or tar.gz) to Blackboard.



## Ver-2

#### Details: [HW2_RNA-Seq_V2.pdf](HW2_RNA-Seq_V2.pdf)
#### Ref: [Texedo2.pdf](Texedo2.pdf)
#### Ballgown R script: [ballgown.R](ballgown.R)
#### Submit
Submit all docs, scripts, results into one PDF or multiple files (docs, pdf, txt, sh, zip, or tar.gz) to Blackboard.


