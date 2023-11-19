# Concise report about the fasta/fa files in a given folder (or its subfolders at any depth)
X=$1
N=$2

# The folder X where to search files (default: current folder)
if [[ -z $X ]]; then
	X=$(pwd)
fi

# A number of lines N (default: 0)
if [[ -z $N ]]; then
	N=0
fi

# the fasta/fa files in a given folder (or its subfolders at any depth)
all_fa_fasta_files=$(find $X -type f -name "*.fasta" -or -name "*fa")

# how many such files there are
echo There are: $(echo $all_fa_fasta_files | wc -w) fa/fasta files in $X folder and its subfolders
