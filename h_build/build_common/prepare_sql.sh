#!/bin/bash

SQL_TARGET_SV=`head -n 1 ../conf/server_list_${TARGET_PRF}.txt`
SQL_FROM_DIR_CID=${API_DIR}/database/company_db
SQL_FROM_DIR_ADMIN=${API_DIR}/database/admin_db
SQL_TO_DIR_CID=${ROOT}/${SERVERS}/${SQL_TARGET_SV}/${SEND}/${RELEASE_DATE}/sql
SQL_TO_DIR_ADMIN=${ROOT}/${SERVERS}/${SQL_TARGET_SV}/${SEND}/${RELEASE_DATE}/sql/admin
SQL_LIST_CID=${SQL_TO_DIR_CID}/list_cid.txt
SQL_LIST_ADMIN=${SQL_TO_DIR_ADMIN}/list_admin.txt

if [ -f ${SQL_LIST_CID} ]; then
  mkdir -p ${SQL_TO_DIR_CID}
  SQL_FILE_LIST=(`cat ${SQL_LIST_CID}`)
  for sql_file in ${SQL_FILE_LIST[*]}
  do
    #echo ${sql_file}
    cp ${SQL_FROM_DIR_CID}/${sql_file} ${SQL_TO_DIR_CID}/
  done
  rm -f ${SQL_LIST_CID}
fi

if [ -f ${SQL_LIST_ADMIN} ]; then
  mkdir -p ${SQL_TO_DIR_ADMIN}
  SQL_FILE_LIST=(`cat ${SQL_LIST_ADMIN}`)
  for sql_file in ${SQL_FILE_LIST[*]}
  do
    #echo ${sql_file}
    cp ${SQL_FROM_DIR_ADMIN}/${sql_file} ${SQL_TO_DIR_ADMIN}/
  done
  rm -f ${SQL_LIST_CID}
fi

