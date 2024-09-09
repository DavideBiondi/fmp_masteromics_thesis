#!/bin/bash
cat *.txt > biblio.bib
sed -i '$ a @online{samples, url={https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA451302&o=acc_s%3Aa}}' biblio.bib
sed -i '$ a @online{trim_galore, url={https://www.bioinformatics.babraham.ac.uk/projects/trim_galore/trim_galore_User_Guide_v0.4.1.pdf}}' biblio.bib
sed -i '$ a @online{fastqc, url={https://mugenomicscore.missouri.edu/PDF/FastQC_Manual.pdf}}' biblio.bib
sed -i '$ a @online{github, url={https://github.com/DavideBiondi/fmp_masteromics_thesis}}' biblio.bib
sed -i '$ a @online{htseq_docs, url={https://htseq.readthedocs.io/en/latest/htseqcount.html}}' biblio.bib
