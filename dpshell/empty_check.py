#!/home/leisen/anaconda3/bin/python3
# -*- coding: UTF-8 -*-

# ********************************************************
# * Author        : LEI Sen
# * Email         : sen.lei@outlook.com
# * Create time   : 2018-12-24 17:56
# * Last modified : 2018-12-24 17:56
# * Filename      : empty_check.py
# * Description   : 
# *********************************************************


import sys
import os
import click
#import subprocess
#import shlex
import platform



HERE = os.path.dirname(os.path.abspath(__file__))
OS_TYPE = platform.platform().split('-')[0]



@click.command()
@click.option(
    'file_type', '--type', '-t',
    help="Specify the file type. ",
    required=False,
#    prompt="Please specify package name",
)
@click.argument(
    'folder_dir', 
    nargs=1, 
    type=click.Path(exists=True, file_okay=False, writable=True), 
    required=False, 
#    default='.',
)
def main(file_dir, file_type):
    """
    Python command line tool to check empty files. 
    """
    command_code = """
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
"""
    os.system(command_code)