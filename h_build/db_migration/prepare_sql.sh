#!/bin/bash

# 固有定数宣言
APP_NAME=ifield_hitachiKenki

# 定数シェル読み込み
. ../build_common/build_slm_const.sh

# 引数共通処理実行
. ../build_common/build_slm_com_getopts.sh

# WEB共通定数
. ../build_common/build_slm_const_web.sh

# SQLファイル転送先サーバ特定
SQL_TARGET_SV=`head -n 1 ../conf/server_list_${TARGET_PRF}.txt`
echo ${TARGET_PRF}
echo ${SQL_TARGET_SV}

# SQLファイル取得元
SQL_FROM_DIR_CID=${API_DIR}/database/company_db
SQL_FROM_DIR_ADMIN=${API_DIR}/database/admin_db

echo "RELEASE_DATE:${RELEASE_DATE}"

# SQLファイル配置先
SQL_TO_DIR_CID=${ROOT}/${SERVERS}/${SQL_TARGET_SV}/${SEND}/${RELEASE_DATE}/sql
SQL_TO_DIR_ADMIN=${ROOT}/${SERVERS}/${SQL_TARGET_SV}/${SEND}/${RELEASE_DATE}/sql/admin

# 転送元SQLフォルダ
FROM_DIR=${ROOT}/${SERVERS}/${SQL_TARGET_SV}/${SEND}/${RELEASE_DATE}/sql

echo "SQL_TO_DIR_CID:${SQL_TO_DIR_CID}"

# SQLファイル指定用設定ファイル
SQL_LIST_CID=./conf/list_cid.txt
SQL_LIST_ADMIN=./conf/list_admin.txt

# CID用SQLファイルの処理
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

# company_admin用ファイルの処理
if [ -f ${SQL_LIST_ADMIN} ]; then
  mkdir -p ${SQL_TO_DIR_ADMIN}
  SQL_FILE_LIST=(`cat ${SQL_LIST_ADMIN}`)
  for sql_file in ${SQL_FILE_LIST[*]}
  do
    #echo ${sql_file}
    cp ${SQL_FROM_DIR_ADMIN}/${sql_file} ${SQL_TO_DIR_ADMIN}/
  done
  
  rm -f ${SQL_LIST_ADMIN}
fi

# リリース先へ転送
rsync -avz ${FROM_DIR} ${SQL_TARGET_SV}:~/release/${RELEASE_DATE}
