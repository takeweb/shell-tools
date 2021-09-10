#!/bin/bash

RELEASE_DATE=`date '+%Y%m%d'`
RELEASE_DIR=/home/ec2-user/release
BACKUP_DIR=${RELEASE_DIR}/${RELEASE_DATE}/bk
DEST_DIR=/var/lib/AtrackSocket/
JAR_FILE=atrackSocket.jar

# リリース日で初作業の場合のみバックアップ取得
if [ ! -d ${BACKUP_DIR} ]; then
    # バックアップ  
    mkdir -p ${BACKUP_DIR}
    
    sudo cp ${DEST_DIR}/${JAR_FILE} ${BACKUP_DIR}/
fi
