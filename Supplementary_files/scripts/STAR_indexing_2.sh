#!/usr/bin/bash

# Decompress the FASTA and GTF files
gunzip -c refs_2/hg19.fa.gz > refs_2/hg19.fa
gunzip -c refs_2/hg19.ensGene.gtf.gz > refs_2/hg19.ensGene.gtf

# Run STAR genomeGenerate
STAR --runThreadN 15 \
     --runMode genomeGenerate \
     --genomeDir genomeIndex_2 \
     --genomeFastaFiles refs_2/hg19.fa \
     --sjdbGTFfile refs_2/hg19.ensGene.gtf \
     --genomeSAindexNbases 14 \
     --genomeSAsparseD 2 \
     --sjdbOverhang 49
# Optionally, remove the decompressed files to save space
#rm refs_2/hg19.fa refs_2/hg19.ensGene.gtf

#hg19.ensGene.gtf.gz
#hg19.fa.gz
