#!/bin/bash

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

TRESHOLD=$((2 * $N))

# the fasta/fa files in a given folder (or its subfolders at any depth)
all_fa_fasta_files=$(find $X -type f -name "*.fasta" -or -name "*fa")
if [[ -z $all_fa_fasta_files ]]; then
    echo "No .fasta or .fa files found. Could you maybe provide us with another folder?"
    exit 1
fi

files_unique_fasta_ids=$(grep ">" $all_fa_fasta_files | awk '{print $1}' | sort | uniq -c | wc -l | awk '{print $1}')
num_of_fa_fasta_files=$(echo "$all_fa_fasta_files" | wc -l | awk '{print $1}')

# how many such files there are and how many unique fasta IDs they have
echo There are: [$num_of_fa_fasta_files] fa/fasta files in [$X] folder and its subfolders which have [$files_unique_fasta_ids] unique fasta IDs

for file in $all_fa_fasta_files; do
    echo
    # whether the file is a symlink or not
    if [[ -h $file ]]; then 
        symbolic_link="Symlink link"
    else
        symbolic_link="NOT Symlink link"
    fi

    # how many sequences there are inside
    num_of_sequences=$(grep ">" $file | wc -l | awk '{print $1}')

    # the total sequence length in each file, i.e. the total number of amino acids or nucleotides of all sequences in the file. NOTE: gaps "-", spaces, newline characters should not be counted
    total_sequence_length=$(grep -v ">" $file | sed 's/-//g' | tr -d '\n' | wc -m | awk '{print $1}')

    # Check if the sequence contains nucleotide characters
    sequences=$(grep -v ">" $file | sed 's/-//g' | tr -d ' ' | tr -d '\n' | tr '[a-z]' '[A-Z]')
    content_type="Unknown"
    if [[ "$sequence" =~ [QEILFPXOZJ] ]]; then
        content_type="Amino Acid"
    else
        count_A=$(echo "$sequences" | grep -o 'A' | wc -l)
        count_C=$(echo "$sequences" | grep -o 'C' | wc -l)
        count_G=$(echo "$sequences" | grep -o 'G' | wc -l)
        count_T=$(echo "$sequences" | grep -o 'T' | wc -l)
        count_U=$(echo "$sequences" | grep -o 'U' | wc -l)
        sum_ACGTU=$((count_A + count_C + count_G + count_T + count_U))

        count_Others=$(echo "$sequences" | grep -o '[^ACGT]' | wc -l)
        if (( sum_ACGTU >= count_Others / 2 )); then
            content_type="Nucleotide"
        else
            content_type="most likely Amino Acid"
        fi
    fi

    echo "=== File [$file] Report === [$symbolic_link] === [$num_of_sequences] sequences inside === Length of [$total_sequence_length] of all sequences === Content type: [$content_type] ==="
    if [[ $N -gt 0 ]]; then
        FILE_LINE_COUNT=$(wc -l < $file)
        if [[ $FILE_LINE_COUNT -le $TRESHOLD ]]; then
            cat $file
        else
            head -n $N $file
            echo ...
            tail -n $N $file
        fi
    fi
done

