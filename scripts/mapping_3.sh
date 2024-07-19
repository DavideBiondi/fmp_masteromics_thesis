#!/usr/bin/bash
for file in *.fq ; do STAR --runThreadN 15 --genomeDir genomeIndex/ --sjdbGTFfile refs/hg19.ncbiRefSeq.gtf --sjdbOverhang 100 --readFilesIn "$file" --outFileNamePrefix output/${file} --quantMode TranscriptomeSAM ; done

