#!/bin/bash

# Extract the header from GO_CC.txt and store it in a bash variable
line_to_insert=$(awk 'BEGIN{FS=OFS="\t"} NR==1 {print $1 "\t" $2 "\t" $4 "\t" $5 "\t" $6 "\t" $10 "\t" $12 "\t" $13}' "$1")

# Now use the extracted header in the awk script with the -v option
awk -v header="$line_to_insert" -v file1="$1" -v file2="$2" '
BEGIN {
    FS = OFS = "\t";
    print "Annotation analysis of the 83 genes differentially expressed (FC >0.5) in CD organoids by DAVID FDR< .05";
    print "UPREGULATED";
    print header;
    ENVIRON["LC_ALL"] = "C";
}

# Classify genes as upregulated or downregulated from sigs_2.tsv
FILENAME == file2 && NR > 1 {
    log2FC = $4 + 0;  # Ensure log2FC is treated as a number
    gene = $1;
    
    # Print the gene and its log2FoldChange value
    print "Processing gene:", gene, "log2FC:", log2FC > "/dev/stderr";
    
    if (log2FC > 0.5) {
        upregulated[gene]++;
    } else if (log2FC < -0.5) {
        downregulated[gene]++;
    }
    next;
}

# Process the GO_CC.txt file
FILENAME == file1 {
    go_term_genes = $6;  # The comma-separated gene list in the GO_CC.txt file
    output = $1 "\t" $2 "\t" $4 "\t" $5 "\t" $6 "\t" $10 "\t" $12 "\t" $13;  # Columns to print
    
    # Split the comma-separated gene list
    n = split(go_term_genes, genes, ",");
    up_count = 0;
    down_count = 0;

    # Count upregulated and downregulated genes
    for (i = 1; i <= n; i++) {
        gene = genes[i];
        gsub(/ /, "", gene);  # Remove any leading or trailing spaces

        if (gene in upregulated) {
            up_count++;
        } else if (gene in downregulated) {
            down_count++;
        }
    }

    # Classify the GO term based on the majority
    if (up_count > down_count) {
        print output > "upregulated_output.txt";
    } else if (down_count > up_count) {
        print output > "downregulated_output.txt";
    }
}

END {
    # Print UPREGULATED GO terms
    if (system("test -s upregulated_output.txt") == 0) {
        while ((getline line < "upregulated_output.txt") > 0) {
            print line;
        }
        close("upregulated_output.txt");
    }

    print "DOWNREGULATED";
    print header;  # Print the header again for downregulated section

    # Print DOWNREGULATED GO terms
    if (system("test -s downregulated_output.txt") == 0) {
        while ((getline line < "downregulated_output.txt") > 0) {
            print line;
        }
        close("downregulated_output.txt");
    }
}
' "$2" "$1"
