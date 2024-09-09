#!/bin/bash
# First, get the common entries from $2 that match any entry in $1
grep -f "$1" -o -w "$2" > common_degs.txt

# Declare an associative array to store common entries
declare -A common_entries

# Read each line from common_degs.txt and store it in the array
while read -r line; do
    common_entries["$line"]=1
done < common_degs.txt

# Create a temp file made of awk filtering
tmp_file=$(mktemp)  # Create a temporary file
awk 'NR>1 {print $2}' "$2" > "$tmp_file"

#Add a check that prints the number of elements in tmp_file
echo -e "Number of elements in tmp_file:\n"
wc -l "$tmp_file"

# Iterate through each entry in common_entries and eliminate the matching lines with sed in place
for entry in "${!common_entries[@]}"; do
    sed -i "/\b$entry\b/d" "$tmp_file"
done
echo -e "Number of elements in tmp_file:\n"
wc -l "$tmp_file"

# Redirect the content of "$tmp_file" to a text file
mv "$tmp_file" uncommon_degs.txt
