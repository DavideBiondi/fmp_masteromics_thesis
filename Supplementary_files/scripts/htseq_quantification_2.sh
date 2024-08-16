#!/bin/bash
#          ls -1 ./output_2/*sortedByCoord*.bam

#filenames=$(ls -1 ./output_2/*sortedByCoord*.bam | xargs -I {} basename {})

#header="Gene_ID $(echo $trimmed_filenames)"
#echo $filepaths
#echo $trimmed_filenames
#!/bin/bash

# List all BAM files
filepaths=$(ls -1 ./output_2/*sortedByCoord*.bam)

# Iterate over each file
for file in $filepaths; do
    filename=$(basename "$file") ; \
    htseq-count -r pos -s reverse "$file" \
    ./refs_2/hg19.ensGene.gtf -t exon -i gene_id --nonunique none \
    -q > ./quantifications_4/${filename:0:10}_counts_exons_reverse.tsv ;
done
# -r pos added for quantifications_4, this comment cannot be added in the for cycle
