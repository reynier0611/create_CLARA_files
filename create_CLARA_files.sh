#!/bin/bash
# ===========================================================================================
# These are the main variables that will need to be changed for different
# users, paths, versions, etcetera.

USER="Rey"
COATJAVA="5b.7.8"
CACHEPATH="/cache/clas12/rg-b/production/decoded/"
OUT_DIR_BASE="/volatile/clas12/"$USER"/"
ROUND="5"
echo
# ===========================================================================================
echo "----------------------------------"
echo "Shell script to create CLARA input"
echo "By: F.Hauenstein  (fhauenst@odu.edu)"
echo "    E.Segarra     (segarrae@mit.edu)"
echo "    R.Cruz-Torres (reynier@mit.edu )"
echo "----------------------------------"
# ===========================================================================================
# Check that an input list and output file are provided
if [ $# -ne 1 ]
then
	echo "Wrong number of arguments provided."
	echo "Please, run this script the following way:"
	echo "./create_CLARA_files.sh run_number"
	echo "Bailing out!"
	exit 1
fi
# ===========================================================================================
# Set the path to the hipo files and save them to '$HIPO_FILES'
HIPO_DIR=$CACHEPATH$COATJAVA"/00"$1
HIPO_FILES=$HIPO_DIR"/*.hipo"
# ===========================================================================================
# Loop over files in '$HIPO_FILES' and save the filenames to a txt file
RUNLIST_FILE=$CLARA_HOME"runlist_"$1".txt"
echo "Now creating file: "$RUNLIST_FILE

for filename in $HIPO_FILES; do
	echo `basename "$filename"` >> $RUNLIST_FILE
done
echo
# ===========================================================================================
# Check whether directory where output files will be saved exists, and if
# it does not, then create it.
OUT_DIR=$OUT_DIR_BASE$1"_round"$ROUND"_hipos"
if ! [ -d $OUT_DIR ]
	then 
	mkdir $OUT_DIR
fi
# ===========================================================================================
# Creating cls file with instructions for CLARA
CLS_FILE=$CLARA_HOME"bandrun_"$1".cls"
rm $CLS_FILE
echo "Now creating file: "$CLS_FILE
echo "set servicesFile "$CLARA_HOME"trackingandband_filtered.yaml" >> $CLS_FILE
echo "set fileList "$CLARA_HOME"runlist_"$1".txt" >> $CLS_FILE
echo "set inputDir "$HIPO_DIR >> $CLS_FILE
echo "set outputDir "$OUT_DIR >> $CLS_FILE
echo "set outputFilePrefix out_" >> $CLS_FILE
echo "set logDir "$CLARA_HOME"log" >> $CLS_FILE
echo "set session "$USER"BAND" >> $CLS_FILE
echo "set description Reco"$1 >> $CLS_FILE
echo "set farm.cpu 16" >> $CLS_FILE
echo "set farm.memory 30" >> $CLS_FILE
echo "set farm.disk 50" >> $CLS_FILE
echo "set farm.time 1440" >> $CLS_FILE
echo "set farm.os centos7" >> $CLS_FILE
echo "set farm.track reconstruction" >> $CLS_FILE
echo "set farm.scaling 16" >> $CLS_FILE
echo "set farm.system jlab" >> $CLS_FILE
echo
# ===========================================================================================
echo "Will run CLARA now"
echo "This sh*t is bananas! B-A-NAN-A-S!"
echo "Will be using hipo files from: "$HIPO_FILES
echo "Cooked hipo files will be saved in: "$OUT_DIR
$CLARA_HOME/bin/clara-shell
