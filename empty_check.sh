#!/bin/bash
# *********************************************************
# * Author        : LEI Sen
# * Email         : sen.lei@outlook.com
# * Create time   : 2018-12-24 16:22
# * Last modified : 2018-12-25 15:50
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
echo "Checking empty files in folder [$1/] ..."
echo ""

file_path=$1/
file_list=$1/*.$2
fp_sub_list=$1/*
suffix=.$2

new_folder=$1_result_stats/

rm -r $1_result_stats
mkdir $1_result_stats
result_f="$1_result_stats/result_stats.csv"

if [ -f $result_f ]; then
    rm $result_f
fi

echo "file_name,size,is_empty" > $result_f

f_num=($f_sub_list)
f_num=${#f_num[@]}
f_num="$(find ${file_path} -mindepth 1 -maxdepth 1 -type d | wc -l)"
f_index=0
f_index_true=0

for fp_sub in $fp_sub_list; do
    if [ -d $fp_sub ]; then
	sub_folder_name=${fp_sub#"$file_path"}
	echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $sub_folder_name"
	f_list=$fp_sub/*.$2
	let f_index=f_index+1
	echo -ne "Progress: ${f_index}/${f_num} (empty: ${f_index_true}) \r"
	for f in $f_list; do
	    f_name=${f#"$fp_sub/"}
	    ## Get file size
	    f_size="$(wc -c < "$f")"
	    if [ $f_size -eq 0 ]; then
		is_empty='Yes'
		let f_index_true=f_index_true+1
		#cp -r $fp_sub $new_folder
		f_wo_ext=${f%"$suffix"}
		cp "$f_wo_ext".* "$new_folder"
		#echo $f_name
		#echo -ne "Progress: ${f_index}/${f_num} (empty: ${f_index_true}) \r"
		#break
	    else
		is_empty='No'
	    fi
	    ## Get final results
	    final_results="${f_name},${f_size},${is_empty}"
	    echo "${final_results}" >> $result_f
	done
    fi
done
echo "Progress: ${f_index}/${f_num} (empty: ${f_index_true})"

echo """
... Done. 
"""

####
exit
####

prefix=$1/
suffix=.$2
new_folder=$1/result_stats/

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
    #file_name="${file/$file_path/}"
    file_name=${file#"$prefix"}
    file_name=${file_name%"$suffix"}
    echo "$file_name"
    ## Get file size
    file_size="$(wc -c < "$file")"
    if [ $file_size == 0 ]; then
	is_empty='Yes'
	cp $file $new_folder
    else
	is_empty='No'
    fi
    ## Get final results
    final_results="${file_name}, ${file_size}, ${is_empty}"
    echo "${final_results}" >> $result_file
done
echo ""
echo "Checking empty files in folder [$1/] ..."
echo ""

file_path=$1/
file_list=$1/*.$2
#echo $file_list
#cd $file_path
prefix=$1/
suffix=.$2
new_folder=$1/result_stats/

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
    #file_name="${file/$file_path/}"
    file_name=${file#"$prefix"}
    file_name=${file_name%"$suffix"}
    echo "$file_name"
    ## Get file size
    file_size="$(wc -c < "$file")"
    if [ $file_size == 0 ]; then
	is_empty='Yes'
	cp $file $new_folder
    else
	is_empty='No'
    fi
    ## Get final results
    final_results="${file_name}, ${file_size}, ${is_empty}"
    echo "${final_results}" >> $result_file
done

echo """
... Done. 
"""
