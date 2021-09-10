#!/bin/bash

RELEASE_DATE=`date '+%Y%m%d'`
RELEASE_DIR=/home/ec2-user/release
BACKUP_DIR=${RELEASE_DIR}/${RELEASE_DATE}/bk
TOMCAT_DIR=/var/lib/tomcat8/webapps

# SQLファイルをコピー
if [ ! -d ../sql ]; then
  mkdir -p ${RELEASE_DIR}/${RELEASE_DATE}/sql
  cp ../sql/*.sql ${RELEASE_DIR}/${RELEASE_DATE}/sql/
fi

if [ ! -d ../sql/admin ]; then
  mkdir -p ${RELEASE_DIR}/${RELEASE_DATE}/sql
  cp ../sql/admin/*.sql ${RELEASE_DIR}/${RELEASE_DATE}/sql/admin/
fi

cd ${RELEASE_DIR}/tools/

# リリース日で初作業の場合のみバックアップ取得
if [ ! -d ${BACKUP_DIR} ]; then
    ./backup_webapp.sh -d ${RELEASE_DATE}
fi

## company_adminへのSQL適用
./exec_sql_files_for_admin.sh -d ${RELEASE_DATE}

## CID・DBへのSQL適用
./exec_sql_files_for_cid.sh -d ${RELEASE_DATE}

