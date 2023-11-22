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

for file in $all_fa_fasta_files; do
	echo === File $file report ===
	unique_fasta_ids_count=$(grep ">" $file | awk '{print $1}' | sort | uniq -c | wc -l)
	echo File $file has $unique_fasta_ids_count unique fasta IDs
	
	if [[ -h $file ]]; then 
		echo File $file is a symbolic link
	else
		echo File $file is not a symbolic link
	fi
	
	num_of_sequences=$(grep ">" $file | wc -l)
	echo File $file contains $num_of_sequences sequences inside.  
done

