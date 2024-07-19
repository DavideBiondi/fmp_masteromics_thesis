#!usr/bin/bash
for file in "$PWD"/*; do filename="${file%.bam}" ;  samtools view -h -o "${filename}.sam" "$file"; done
