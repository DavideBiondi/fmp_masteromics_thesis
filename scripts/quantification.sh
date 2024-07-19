#!/usr/bin/bash
for file in file_fastq/bams/*Aligned.to*.bam ; do rsem-calculate-expression --num-threads 15 --bam --estimate-rspd --forward-prob 0 --seed 12345 "$file" txIndex/RSEMref quantifications_2/$(basename "$file" .bam)  ; done
