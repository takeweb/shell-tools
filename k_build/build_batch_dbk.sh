#!/bin/bash

# 共通シェル実行
. build_const.sh
. build_const_dbk.sh
. build_const_batch.sh

# 共通処理シェル読み込み
. build_com.sh
. build_com_batch.sh

# バッチのビルド処理
# バッチプロジェクトのビルド
build_batch() {
    echo ${APP_NAME}" build start"
    cd ${ROOT}/${APP_DIR}/${APP_NAME}

    # 各サーバ用コピー
    for SERVER_INFO in ${!SERVER_INFOS[@]};
    do
        DIRECTORY=${SERVER_INFO}
        echo "DIRECTORY = ${DIRECTORY}"

        mvn clean
        if [ ${DIRECTORY} = "develop_*" ]; then
            mvn package -P ${PROFILE_BATCH_DEV}
        else
            mvn package -P ${PROFILE_BATCH_PRD}
        fi
        cp ${ROOT}/${APP_DIR}/${APP_NAME}/target/${APP_NAME}.jar ${ROOT}/${RELEASE}/${SERVERS}/${DIRECTORY}/${SEND}/${RELEASE_DATE}/${APP_NAME}/
    done
    echo ${APP_NAME}" build e n d"
}

usage_exit() {
    echo "Usage : $0 [-n app_name] [-d yyyymmdd] [-m mode(init/mod)]" 1>&2
    exit 1
}

# 引数無し対策
ARG=$1
if [ "$ARG" = "" ]; then
    usage_exit
    exit 1
fi

#引数受け取り
while getopts n:d:m:h OPT
do
    case $OPT in
        n)
            # プロジェクト名
            APP_NAME=$OPTARG
            if [ "$APP_NAME" = "" ]; then
                echo "プロジェクト名を指定してください。"
                exit 1
            fi
            ;;
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

# 前準備
clean ${RELEASE_DATE} ${APP_NAME}
prepare ${RELEASE_DATE} ${APP_NAME}

# リリースモード省略時は「mod」
if [ "${RELEASE_MODE}" = "" ]; then
    RELEASE_MODE="mod"
fi

# 引数により処理切り替え
    if [ ! -d ${ROOT}/${APP_DIR}/${APP_NAME} ]; then
        echo "指定されたプロジェクト「${APP_NAME}」は、作業ディレクトリに存在しません。"
        exit 1
    else
        build_batch
        if [ ${RELEASE_MODE} = "init" ]; then
            copy_shell
            copy_libs
        fi
    fi

exit 0