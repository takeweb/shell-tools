#!/bin/bash

# リリースフォルダを設定
SERVERS_DIR="/mydata/hitachikenki_build/release/servers"

# WORKディレクトリ
WORK_DIR=/mnt/c/Users/oishi/Documents/99_WORK

# 作業モードは「recv」固定
WORK_MODE=recv

# OSユーザ
OS_USER="ec2-user"

# アップロード対象ディレクトリ
TARGET_DIR="/home/${OS_USER}/release"

# 対象を取得(prd/stg/reha/poc/dev)
read -p "対象サーバを入力してください。(prd/stg/reha/poc/dev): " TARGET
if [ "${TARGET}" = "" ]; then
    TARGET="dev"
    "デフォルト「dev」で処理します。"
fi

# ダウンロード対象ファイルリスト取得
FILE_LIST=(`cat ./conf/file_list.txt`)

# サーバリストを取得
SERVER_LIST=(`cat ../conf/server_list_${TARGET}.txt`)

# 作業日省略時は当日
if [ "${WORK_DATE}" = "" ]; then
    WORK_DATE=`date '+%Y%m%d'`
fi

# ダウンロード
for target_server in ${SERVER_LIST[@]}
do
    echo ${target_server}
    for target_file in ${FILE_LIST[@]}
    do
        echo ${target_file}
        echo ${WORK_DIR}/2020/202011/${WORK_DATE}/${target_server}/
        rsync -avz ${target_server}:${target_file} ${WORK_DIR}/${WORK_DATE:0:4}/${WORK_DATE:0:6}/${WORK_DATE}/${target_server}/
    done
done

exit $?
