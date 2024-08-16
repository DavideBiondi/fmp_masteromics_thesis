#!/usr/bin/awk -f

BEGIN {
    # Prepare the filenames array
    cmd = "ls -1 SRR*_reverse.tsv"
    i = 0
    
    # Open a pipe to the command and read its output line by line
    while ((cmd | getline line) > 0) {
        filenames[i++] = line
    }
    
    # Close the pipe
    close(cmd)
}

# Process the main file
FNR == NR {
    OFS = FS = "\t"
    # Initialize the line array with the first two fields
    line_2[$1] = $1
    next
}

# Process the other files
{
    OFS = FS = "\t"
    if ($1 in line_2) {
        # Append the fourth field to the existing entry in the line array
        line_2[$1] = line_2[$1] OFS $2
    }
}

END {
    # Print all entries in the line array
    for (key in line_2) {
        print line_2[key]
    }
}
