#!/bin/bash
for file in *.fq ; do STAR --runThreadN 15 --genomeDir genomeIndex_2/ \
 --sjdbGTFfile refs_2/hg19.ensGene.gtf --sjdbOverhang 49 \
 --readFilesIn "$file" --outFileNamePrefix output_2/${file} \
 --quantMode TranscriptomeSAM GeneCounts --outStd Log --outSAMtype BAM SortedByCoordinate ; done
