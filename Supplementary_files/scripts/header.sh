#!/bin/bash
filenames=$(ls -1 SRR*_reverse.tsv | xargs -I {} basename {})
trimmed_filenames=$(for filename in $filenames; do echo -n "${filename:0:10}\t"; done | sed 's/\t$//g')
header="Ensembl_ID\t$trimmed_filenames"
echo -e $header
sed -i "1i $header" all_counts_compared.tsv 
sed -i '1s/[[:space:]]*$//' all_counts_compared.tsv
head all_counts_compared.tsv
