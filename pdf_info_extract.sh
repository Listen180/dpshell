#!/bin/bash
# *********************************************************
# * Author        : LEI Sen
# * Email         : sen.lei@outlook.com
# * Create time   : 2018-12-25 18:23
# * Last modified : 2018-12-25 18:23
# * Filename      : pdf_info_extract.sh
# * Description   : 
# *********************************************************


if [ "$1" == "" ]; then
    echo "parameter 1 missing: file folder location needed!"
    exit
fi

echo ""
echo "Extracting page number and file size of PDF in folder [$1/] ..."
echo ""

file_path=$1/
file_list=$1/*.pdf
new_folder=$1_pdf_sub/
new_folder_stat=$1_pdf_sub/result_stats/

rm -r "$new_folder"
mkdir "$new_folder"
mkdir "$new_folder_stat"
result_f="${new_folder_stat}result_stats.csv"
if [ -f $result_f ]; then
    rm $result_f
fi

file_num=($file_list)
file_num=${#file_num[@]}

f_count=0
f_index=0
f_index_true=0

echo "file_name,rwx_au,size,page_num" > $result_f

rm -r $1/sub_folder
mkdir $1/sub_folder


for file in $file_list; do
	let f_index=f_index+1
    echo -ne "Progress: ${f_index}/${file_num} (succeed: ${f_index_true}) \r"
    if [ ! -f "$file" ]; then
        echo "[!Warning] file not fount: "${file}""
    else
        file_sub1="$(echo "$file" | grep ".*年年度报告（.*）\.pdf")"
        file_sub2="$(echo "$file" | grep ".*年年度报告\.pdf")"
        file_sub_sub1="$(echo "$file_sub1" | grep "已取消")"
        file_sub_sub2="$(echo "$file_sub1" | grep "英文")"
        if [ -z "$file_sub1" ] && [ -z "$file_sub2" ]; then
            continue
        elif [ ! -z "$file_sub_sub1" ] || [ ! -z "$file_sub_sub2" ]; then
            continue
        else
            cp "$file" "$new_folder"
            file_name=${file#"$file_path"}
            echo ">>>>>>>>>>>>>>>>>>>> $file_name"
            let f_index_true=f_index_true+1
            #echo -ne "Progress: ${f_count}/${file_num} \r"
        fi
        ##
        if [ -r "$file" ]; then
           read_au="r"
        else
           read_au="-"
        fi
        if [ -w "$file" ]; then
           write_au="w"
        else
           write_au="-"
        fi
        if [ -x "$file" ]; then
           ex_au="x"
        else
           ex_au="-"
        fi
        rwx_au=$read_au$write_au$ex_au
        
        ## Get PDF info
    if [[ "$OSTYPE" == "darwin"* ]]; then
            pdf_page="$(mdls -name kMDItemNumberOfPages $file | awk -F'=' '{ print $2 }')"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            pdf_page="$(pdfinfo "$file" | grep Pages | awk '{print $2}')"
    fi
        pdf_size="$(wc -c <"$file")"
#        div=1024
#        pdf_size=expr $pdf_size/$div
        
        final_result=""$file_name",${rwx_au},$pdf_size,$pdf_page"
        echo "${final_result}" >> $result_f
    fi
done
echo "Progress: ${f_index}/${file_num} (succeed: ${f_index_true})"

echo "    ${f_index_true} PDF file in this folder has been successfully used: "
echo "        (a csv file has been save to the original folder.)"

echo """
... Done. 
"""