FILE=$1
LINE_COUNT=$2

if [[ -z $LINE_COUNT ]]; then
	LINE_COUNT=3
fi

FILE_LINE_COUNT=$(wc -l < $FILE)
TRESHOLD=$((2 * $LINE_COUNT))

if [[ $FILE_LINE_COUNT -le $TRESHOLD ]]; then
	# I think the warning should be here saying that the file is smaller than the treshold
	# echo "The file $FILE is smaller than the threshold of $THRESHOLD"
	cat $FILE
else
	echo "The file $FILE has more lines than $TRESHOLD"
	head -n $LINE_COUNT $FILE
	echo ...
	tail -n $LINE_COUNT $FILE
fi

