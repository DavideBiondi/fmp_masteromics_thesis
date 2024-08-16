#!/bin/bash
for file in *Gene.out.tab; do awk -v file=$file 'NR>4 {n=n+$2 ; m=m+$3 ;o=o+$4}END{print "For "file":\n","Counts for unstranded RNA-seq reads is",n"\n","Counts for stranded RNA-seq reads on first strand is",m"\n","Counts for stranded RNA-seq reads on the second strand (reverse strand) is", o}' "$file" >> report_on_star_counts.txt ; done
