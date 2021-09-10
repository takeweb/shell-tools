#!/bin/bash

RELEASE_DATE=`date '+%Y%m%d'`
RELEASE_DIR=/home/ec2-user/release
BACKUP_DIR=${RELEASE_DIR}/${RELEASE_DATE}/bk
TOMCAT_DIR=/var/lib/tomcat8/webapps

cd ${RELEASE_DIR}/tools/

# リリース日で初作業の場合のみバックアップ取得
if [ ! -d ${BACKUP_DIR} ]; then
    ./backup_webapp.sh -d ${RELEASE_DATE}
fi

## Apache、Tomcat停止
sudo /etc/init.d/httpd stop
sudo /etc/init.d/tomcat8 stop

