#!/bin/bash
awk '1' sigs_gene_names.tsv | xargs -I {} pdfgrep -m 1  {} ../../41598_2019_Article_43426.pdf | grep -o -f sigs_gene_names.tsv | awk '!seen[$0]++' \
 > comm_sigs_in_article.txt
#The first awk command select all the lines of the tab separated values file named sigs\_2.tsv, besides the first record, of which it prints just the second field, 
#which contains the official gene symbol. The output is then redirected to another tab separated values file (even if it is composed by just one field). The second 
#command is a pipeline: awk print every single line, and every single line is stored by xargs as a single string to be searched by pdfgrep, "-m 1" option capture only 
#one match of the single string per line, and returns the matched line, then grep works on these matched lines and returns the exact matches with -o option, while -f 
#provides the file with the patterns to search in these remaining lines selected from the article by pdfgrep. After that, all the single matches - also the ones that 
#are repeated multiple times in the same matched lines of the article - get processed by awk, which stores every match into an associative array called seen[\$0], where
#\$0 is the matched gene symbol and the key of the array, while "++" is the value for every key: it gets greater of one unit, for every single key/gene symbol added in 
#the array line after line. So awk prints what is not in the array, because "!" is a negation symbol: so if the gene symbol is encountered for the first time in the 
#input, it gets printed and then added into the associative array, if awk finds the same gene symbol in another line, it does not print it because it is already in the 
#array. So the final awk command prints all the gene symbols found in the article, only one time. The output is then redirected to the file comm\_sigs\_in\_article.txt.

