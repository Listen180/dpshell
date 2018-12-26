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
    required=True,
#    prompt="Please specify package name",
)
@click.argument(
    'file_dir', 
    nargs=1, 
    type=click.Path(exists=True, file_okay=False, writable=True), 
    required=True, 
#    default='.',
)
def main(file_dir, file_type):
    """
    Python command line tool to check empty files. 
    """
    print('')
    print(f'Checking empty files in folder [{file_dir}] ...')
    print('')
    command_code = f"""
file_path={file_dir}/
file_list={file_dir}/*.{file_type}
prefix={file_dir}/
suffix=.{file_type}
new_folder={file_dir}/result_stats/

rm -r {file_dir}/result_stats
mkdir {file_dir}/result_stats
result_file="{file_dir}/result_stats/result_stats.csv"
""" + """
if [ -f $result_file ]; then
    rm $result_file
fi
""" + """
echo "file_name,size,is_empty" > $result_file
""" + """
for file in $file_list; do
    file_name=${file#"$prefix"}
    #file_name=${file_name%"$suffix"}
    echo "$file_name"
    ## Get file size
    file_size="$(wc -c < "$file")"
    if [ $file_size -eq 0 ]; then
        is_empty='Yes'
        cp $file $new_folder
    else
        is_empty='No'
    fi
    ## Get final results
    final_results="${file_name},${file_size},${is_empty}"
    echo "${final_results}" >> $result_file
done
"""
    #print(command_code)
    os.system(command_code)


if __name__ == '__main__':
    main()