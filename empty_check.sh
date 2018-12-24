#!/bin/bash
# *********************************************************
# * Author        : LEI Sen
# * Email         : sen.lei@outlook.com
# * Create time   : 2018-12-24 16:22
# * Last modified : 2018-12-24 16:22
# * Filename      : empty_check.sh
# * Description   : 
# *********************************************************

## Make sure you have the foder location specified. 
if [ "$1" == "" ]; then
    echo "parameter 1 missing: file folder location needed!"
    exit
fi

if [ "$2" == "" ]; then
    echo "parameter 2 missing: file type needed!"
    exit
fi

echo ""
echo """Checking empty files in folder [$1/] ..."""
echo ""

file_path=$1/
file_list=$1/*.$2
#echo $file_list
#cd $file_path

f_num=($file_list)
file_num_total=${#f_num[@]}

f_index=0

rm -r $1/result_stats
mkdir $1/result_stats
result_file="$1/result_stats/result_stats.csv"

if [ -f $result_file ]; then
    rm $result_file
fi

echo "file_name, size, is_empty" > $result_file

for file in $file_list; do
    file_name="${file/$file_path/}"
    echo "$file_name"
    ## Get file size
    file_size="$(wc -c < "$file")"
    if [ $file_size == 0 ]; then
	is_empty='Yes'
    else
	is_empty='No'
    fi
    ## Get final results
    final_results="${file_name}, ${file_size}, ${is_empty}"
    echo "${final_results}" >> $result_file
done
