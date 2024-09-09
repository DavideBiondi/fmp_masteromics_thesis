#!/usr/bin/awk -f
BEGIN {FS="\t"}
NR > 1 {
if ($4 > 0) {n++} else {m++}
}
END {
print "There is a total of " n " overexpressed genes\n" ;
print "There is a total of " m " underexpressed genes\n";
print "Over a total of " NR-1 " differentially expressed genes" 
}
