#!/bin/bash

INPUT_FILE=./input.txt
OUTPUT_FILE=./output.txt
SQL_FILE=./exec_sql_for_research.sql
ADMIN_DB=slm-rehearsal-ifieldadmin.clmpmxk6rslp.ap-northeast-1.rds.amazonaws.com
COMPANY_DB=slm-rehearsal-aurora-cid.clmpmxk6rslp.ap-northeast-1.rds.amazonaws.com

# 前回出力ファイルの削除
if [ -f ${OUTPUT_FILE} ]; then
  rm -f ${OUTPUT_FILE}
fi

# 管理DBから会社IDリストを取得
export PGPASSWORD=adminpass0420
val=`psql -U adminuser -d company_admin -t -h ${ADMIN_DB} << _EOF
select
    id
from
    companies
order by
    id
_EOF`

# 各会社用DBへSQLファイルを実行
export PGPASSWORD=ifieldpass
companies=($val)
for company_id in ${companies[*]}
do
  echo company_${company_id}
  while read line
  do
    list=(${line//,/ })
    imei=${list[0]}
    locate_date=${list[1]}
    #echo "IMEI:${imei}"
    #echo "locate_date:${locate_date}"
    hit=`psql -U ifielduser -d company_${company_id} -h ${COMPANY_DB} -f ${SQL_FILE} -t -A -F , -v imei="'${imei}'" -v locate_date="'${locate_date}'"`

    if [ -n "${hit}" ]; then
      echo ${hit}
      echo ${hit} >> ${OUTPUT_FILE}
    fi
  done < ${INPUT_FILE}
done
exit $?
