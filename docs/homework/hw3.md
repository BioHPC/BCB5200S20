---
layout: page
title: Lab HW #3 (metagenomics lab)
subtitle: Lab HW #3 (metagenomics lab) (50 points)
---

### Due
Fri, Apr 24 2020, 11:59 PM

### Homework (Ver 1)
Metagenomics WGS Lab

Complete the metagenomics lab and answers from Q1 to Q10.

### Important
Run all Linux commands with shell to keep the commands. Then, provide the shell (or can copy/paste into your document)

### Submit
Submit all docs, scripts, results into one PDF or multiple files (docs, pdf, txt, sh, zip, or tar.gz) to Blackboard.

### Humann2 step error handling
I emailed you about the error and details. Belows are just compact steps for you to install and test the Humann2

1. Log-in to hopper.slu.edu
2. Check your python version to ensure your python version is Python 2.7.5.  
`$ python --version`
3. If your python version is 2.7.5, skip the below step 4.
4. If your python version is not 2.7.5, you may have your own conda or virtual environment. If you can work the lab without a problem, it is OK. If you have any problem, please deactivate all your conda or virtual environment and follow the below lines.
5. Now you are ready to set up the programs. Let us make a conda environment for this.  
`$ conda create -n bcb5250`
6. You will be asked to Proceed ([y]/n)? Then, click y and enter.
7. Conda will message you to update conda by running $ conda update -n base -c defaults conda. Do not run this. It will take long long time.
8. Then, activate this environment. Then you will see (bcb5250) environment at the head of the line.  
`$ conda activate bcb5250`
9. Install bowtie2 with a Python2 build as below.  
`$ conda install -c bioconda bowtie2=2.3.5.1=py27he513fc3_0`
10. You will be asked to Proceed ([y]/n) to install many packages. Click y and enter.
11. Install MetaPhlAn2 with a lower version (2.7.7) to work with the Humann2 without problem. Copy the database directly to avoid any issues by slow network.  
`$ conda install -c bioconda metaphlan2=2.7.7`  
`cp -$ /public/ahnt/courses/bcb5250/metagenomics_wgs_lab/metaphlan_databases ~/.conda/envs/bcb5250/bin/`
12. You will be asked to Proceed ([y]/n) to install many packages like previous. Click y and enter, then wait.
13. Now, install Humann2 using pip, not conda as below:  
`$ pip install humann2`
14. You will get some Yellow message about Python 2.7 won't be supported, but it is OK for this lab. Just check whether you got this message.
15. Install Humann2 databases.  
`$ humann2_databases --download chocophlan DEMO humann2_database_downloads`.  
`$ humann2_databases --download uniref DEMO_diamond humann2_database_downloads`
16. The database will be downloaded into your HomeDirectory/humann2_database_downloads/. You don't need to go to the directory.
17. Now, all installations are done. Let us test Humann2 webpage test dataset. Download the demo file as below:  
`$ wget https://bitbucket.org/biobakery/biobakery/raw/tip/demos/biobakery_demos/data/humann2/input/demo.fastq`
18. Run the Humann2 demo.  
`$ humann2 --input demo.fastq --output demo_fastq`
19. Then, you will get the demo results.
  >demo_fastq/demo_genefamilies.tsv
  >demo_fastq/demo_pathabundance.tsv
  >demo_fastq/demo_pathcoverage.tsv
20. Finally, you can run the Humann2 for our lab.

### Homework (Ver 2)

#### If you have software compatibility issues of above lab, you can alternatively run MetaPhlAn2 tutorial [(link)](https://bitbucket.org/biobakery/biobakery/wiki/metaphlan2). 

The software is installed at ahnt@hopper:/public/ahnt/courses/bcb5250/metagenomics_wgs_lab/metaphlan2/. So add the path into your .bashrc file. You can also install it by yourself if you want.

#### Requirements
- I request you to run only "Create taxonomic profiles" to get "merged_abundance_table.txt". 
- Run each step and take a screen shot to prove of your running.
- There are bullet points of questions in the tutorial. Try to answer those questions.
- Submit the merged_abundance_table.txt and report file (PDF or docx) containing those screenshots and your answers for the bullet questions. 
