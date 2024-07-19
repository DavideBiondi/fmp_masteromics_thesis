#!/usr/bin/bash
STAR --runThreadN 15 --runMode genomeGenerate --genomeDir genomeIndex --genomeFastaFiles refs/hg19.fa --sjdbGTFfile refs/hg19.ncbiRefSeq.gtf --genomeSAindexNbases 14 --genomeSAsparseD 2

