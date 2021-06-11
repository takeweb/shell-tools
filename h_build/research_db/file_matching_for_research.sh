#!/bin/bash

INPUT_FILE=./input.txt
OUTPUT_FILE=./output.txt
RESULT_FILE=./result.txt

# 前回出力ファイルの削除
if [ -f ${RESULT_FILE} ]; then
  rm -f ${RESULT_FILE}
fi

while read line
do
  list=(${line//,/ })
  imei=${list[0]}
  locate_date=${list[1]}
  hantei_flg=0
  #echo "IMEI:${imei}"
  #echo "locate_date:${locate_date}"
  
  while read line2
  do
    out_list=(${line2//,/ })
    out_imei=${out_list[0]}
    out_locate_date=${out_list[1]}
    #echo "OUT_IMEI:${out_imei}"
    #echo "OUT_locate_date:${out_locate_date}"
  
    if [ ${imei} = ${out_imei} ] && [ ${locate_date} = ${out_locate_date} ]; then
      hantei_flg=1
      break
    fi
  done < ${OUTPUT_FILE}
  echo ${imei}","${locate_date}","${hantei_flg} >> ${RESULT_FILE}
done < ${INPUT_FILE}

exit $?
