#!/bin/bash

# 定数シェル読み込み
. build_const.sh

# 土木専用定数シェル読み込み
. build_const_dbk.sh

# OSユーザ、ホームディレクトリを設定
OS_USER="root"
TARGET_DIR=/${OS_USER}/${RELEASE}

usage_exit() {
    echo "Usage : $0 [-m module(all/web/api)] [-s release_server(dev_kajima_hirakata/dev_kajima_hirakata_new)] [-d yyyymmdd]" 1>&2
    exit 1
}

#引数受け取り
while getopts m:d:s:h OPT
do
    case $OPT in
        d)
            # リリース日(yyyymmdd形式)
            RELEASE_DATE=$OPTARG
            ;;
        m)
            # リリースモジュール
            RELEASE_MODULE=$OPTARG
            ;;
        s)
            # リリース対象サーバ(複数の場合はカンマ区切り)
            RELEASE_SERVERS=$OPTARG
            ;;
        h)
            #ヘルプ
            usage_exit
            ;;
        *)
            #ヘルプ
            usage_exit
            ;;
    esac
done

# リリース日指定：省略時は当日
if [ "${RELEASE_DATE}" = "" ]; then
    RELEASE_DATE=`date '+%Y%m%d'`
fi

# リリースモジュール指定：省略時は全モジュール
if [ "${RELEASE_MODULE}" = "" ]; then
    RELEASE_MODULE="*"
fi

# リリース対象サーバ指定：省略時は全サーバ
if [ ! "${RELEASE_SERVERS}" = "" ]; then
    select_server ${RELEASE_SERVERS}
fi

# SCP
for SERVER_INFO in ${!SERVER_INFOS[@]};
do
    TARGET_SERVER=${SERVER_INFO}
    scp -r ${KAJIMA_RELEASE}/${TARGET_SERVER}/${SEND}/${RELEASE_DATE}/${RELEASE_MODULE} ${OS_USER}@${TARGET_SERVER}:/${TARGET_DIR}/${RELEASE_DATE}
done
