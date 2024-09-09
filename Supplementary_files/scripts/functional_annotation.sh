#!/bin/bash
gawk -v file1="$1" -v file2="$2" '

BEGIN {
    FS = "\t";  # Set field separator to tab
    OFS = "\t"; # Set output field separator to tab
}

# Function to join array elements with a separator
function join(arr, sep, i, s) {
    s = arr[1];  # Start with the first element
    for (i = 2; i <= length(arr); i++) {
        s = s sep arr[i];
    }
    # Debugging: Print the joined string
    print "Debug: Joined string:", s > "/dev/stderr";
    return s;  # Return the joined string
}

# Classify genes as upregulated or downregulated from sigs_2.tsv
FILENAME == file2 && NR > 1 {
    log2FC = $4 + 0; # Ensure log2FC is treated as a number
    gene = $1;
    symbol = $2; # Get the gene symbol

    if (log2FC > 0.5) {
        upregulated[gene] = symbol;
    } else if (log2FC < -0.5) {
        downregulated[gene] = symbol;
    }
    next;
}

# Process functional_annotation_table.tsv
FILENAME == file1 && (NR > 3 && NR < 19 || NR > 20 && NR <= 29) {
    # Split the fifth column by commas
    n = split($5, arr, ",");
    
    for (i = 1; i <= n; i++) {
        gsub(/^[ \t]+|[ \t]+$/, "", arr[i]);  # Remove leading and trailing spaces
        # Debugging: Print the original element
        print "Debug: Original arr[" i "]:", arr[i] > "/dev/stderr";

        # Check if the gene is in the upregulated or downregulated arrays
        if (arr[i] in upregulated) {
            arr[i] = "UP:" upregulated[arr[i]];
            print "Debug: Modified arr[" i "]:", arr[i] > "/dev/stderr";  # Debugging
        } else if (arr[i] in downregulated) {
            arr[i] = "DOWN:" downregulated[arr[i]];
            print "Debug: Modified arr[" i "]:", arr[i] > "/dev/stderr";  # Debugging
        } else {
            print "Debug: arr[" i "] not found in upregulated or downregulated" > "/dev/stderr";  # Debugging
        }
    }
    
    # Join the modified array back into a string
    $5 = join(arr, ",");
    # Store the modified line in an array
    modified_lines[NR] = $0;
}

# Print the contents of the upregulated and downregulated arrays
END {
    print "Debug: Upregulated genes:" > "/dev/stderr";
    for (gene in upregulated) {
        print gene, ":", upregulated[gene] > "/dev/stderr";
    }

    print "Debug: Downregulated genes:" > "/dev/stderr";
    for (gene in downregulated) {
        print gene, ":", downregulated[gene] > "/dev/stderr";
    }
}

' "$1" "$2"
