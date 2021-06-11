#!/bin/bash

# ビルド対象アプリ名
APP_NAME="location-master-uploader"

# 定数シェル読み込み
. build_const.sh
. build_const_dbk.sh
. build_const_batch.sh

# 共通処理シェル読み込み
. build_com.sh
. build_com_batch.sh

# location-master-uploaderビルド
build() {
    echo "${APP_NAME} build start"
    echo ${ROOT}/${APP_DIR}/${APP_NAME}
    cd ${ROOT}/${APP_DIR}/${APP_NAME}

    # location-uploader・ビルド&コピー
    for SERVER_INFO in ${!SERVER_INFOS[@]};
    do
        DIRECTORY=${SERVER_INFO}
        PROFILE=${SERVER_INFOS[$SERVER_INFO]}

        echo "DIRECTORY = ${DIRECTORY}"
        echo "PROFILE   = ${PROFILE}"

        mvn clean
        mvn package -P ${PROFILE}
        mv ${ROOT}/${APP_DIR}/${APP_NAME}/target/${APP_NAME}.jar ${ROOT}/${RELEASE}/${SERVERS}/${DIRECTORY}/${SEND}/${RELEASE_DATE}/${APP_NAME}/
    done
    echo "${APP_NAME} build e n d"
}

usage_exit() {
    echo "Usage : $0 [-d yyyymmdd] [-m mode(init/mod)]" 1>&2
    exit 1
}

# 引数無し対策
ARG=$1
if [ "$ARG" = "" ]; then
    usage_exit
    exit 1
fi

#引数受け取り
while getopts d:m:h OPT
do
    case $OPT in
        d)
            # リリース日(yyyymmdd形式) ※省略時は当日
            RELEASE_DATE=$OPTARG
            if [ "$RELEASE_DATE" = "" ]; then
                RELEASE_DATE=`date '+%Y%m%d'`
            fi
            ;;
        m)
            # リリースモード
            RELEASE_MODE=$OPTARG
            ;;
        *)
            #ヘルプ
            usage_exit
            ;;
    esac
done

# 前準備
clean ${RELEASE_DATE} ${APP_NAME}
prepare ${RELEASE_DATE} ${APP_NAME}

# リリースモード省略時は「mod」
if [ "${RELEASE_MODE}" = "" ]; then
    RELEASE_MODE="mod"
fi

# ビルド
build
if [ "${RELEASE_MODE}" = "init" ]; then
    copy_shell
    copy_libs
fi
