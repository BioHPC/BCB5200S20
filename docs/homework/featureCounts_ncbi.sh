featureCounts -p -T 12 -a ncbi_ref/GCF_000146045.2_R64_genomic.gtf -o feature_count_ncbi/SRR1066657.txt ./star_align_ncbi/SRR1066657Aligned.sortedByCoord.out.bam
featureCounts -p -T 12 -a ncbi_ref/GCF_000146045.2_R64_genomic.gtf -o feature_count_ncbi/SRR1066657.multimap.txt -M ./star_align_ncbi/SRR1066657Aligned.sortedByCoord.out.bam
featureCounts -p -T 12 -a ncbi_ref/GCF_000146045.2_R64_genomic.gtf -o feature_count_ncbi/SRR1066657.multimap.overlap.txt -M -O ./star_align_ncbi/SRR1066657Aligned.sortedByCoord.out.bam
