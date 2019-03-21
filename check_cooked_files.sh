#!/bin/bash
echo
# ===========================================================================================
echo "----------------------------------"
echo "Shell script to check cooked files"
echo "By: F.Hauenstein  (fhauenst@odu.edu)"
echo "    E.Segarra     (segarrae@mit.edu)"
echo "    R.Cruz-Torres (reynier@mit.edu )"
echo "----------------------------------"
# ===========================================================================================
# Check that an input list and output file are provided
if [ $# -ne 3 ]
then
	echo "Wrong number of arguments provided."
	echo "Please, run this script the following way:"
	echo "./check_cooked_files.sh /input/files/directory/ /cooked/files/directory/ run_number"
	echo "Bailing out!"
	exit 1
fi
# ===========================================================================================
# Set the path to the hipo files and save them to '$HIPO_INFILES'
HIPO_INFILES=$1"*.hipo"
HIPO_OUFILES=$2"*.hipo"
# ===========================================================================================
NINPUT=$(ls -f $HIPO_INFILES | wc -l)
echo "Number of files in input directory: "$NINPUT

CTR=0

FILE_DOESNTEX="log_"$3"_doNotExist.txt"
FILE_TOOSMALL="log_"$3"_tooSmallFile.txt"

# Loop over all expected cooked files in the output directory
while [ $CTR -le $NINPUT ]
do
	if [ $CTR -lt 10 ]
	then
		FILENUM="0000"$CTR
	elif [ $CTR -lt 100 ] 
	then
		FILENUM="000"$CTR
	elif [ $CTR -lt 1000 ]
	then
		FILENUM="00"$CTR
	elif [ $CTR -lt 10000 ]
        then
		FILENUM="0"$CTR
	else
		FILENUM=$CTR
	fi

	# Create filename for the expected cooked file
	CANDIDATE_FILE=$2"out_clas_00"$3".evio."$FILENUM".hipo"

	# if file does not exist, save the filename to txt file $FILE_DOESNTEX
	if [ ! -f $CANDIDATE_FILE ]
	then
		echo "Expected file: "$CANDIDATE_FILE" does not exist" >> $FILE_DOESNTEX
	# if file exists, but it has a size which is too small, save the filename to txt file $FILE_TOOSMALL
	elif [ $(wc -c < $CANDIDATE_FILE) -lt 10000000 ]
	then
		echo "File: "$CANDIDATE_FILE" is smaller than the rest" >> $FILE_TOOSMALL
	fi

	((CTR++))
done
echo
