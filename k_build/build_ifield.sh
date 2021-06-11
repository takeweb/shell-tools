#!/bin/bash

###########################################################
# 直接起動不可!!!
# 必ず下記のいずれかから起動すること！
# build_ifield_dbk.sh   鹿島建設・土木用iFieldビルド
# build_ifield_sps.sh   鹿島建設・日下川用iFieldビルド
###########################################################

# 定数シェル読み込み
. build_const_ifield.sh

# ifield-apiビルド
build_ifield-api() {
    echo "ifield-api build start"
    cd ${ROOT}/${APP_DIR}/${API}

    # ifield-api・各サーバ用コピー
    for SERVER_INFO in ${!SERVER_INFOS[@]};
    do
        DIRECTORY=${SERVER_INFO}
        PROFILE=${SERVER_INFOS[$SERVER_INFO]}

        echo "DIRECTORY = ${DIRECTORY}"
        echo "PROFILE   = ${PROFILE}"

        # ifield-api・ビルド&コピー(Mavenプロファイル毎)
        mvn clean
        mvn package -P ${PROFILE}
        mv ${ROOT}/${APP_DIR}/${API}/target/${API}.war ${ROOT}/${RELEASE}/${SERVERS}/${DIRECTORY}/${SEND}/${RELEASE_DATE}/${APP_NAME}/
    done
}

# ifield-webビルド
build_ifield-web() {
    echo "ifield-web build start"
    cd ${ROOT}/${APP_DIR}/${WEB}

    # ifield-web・各サーバ用コピー
    for SERVER_INFO in ${!SERVER_INFOS[@]};
    do
        DIRECTORY=${SERVER_INFO}
        PROFILE=${SERVER_INFOS[$SERVER_INFO]}

        echo "DIRECTORY = ${DIRECTORY}"
        echo "PROFILE   = ${PROFILE}"

        # ifield-web・ビルド(Mavenプロファイル毎)
        mvn clean
        mvn package -P ${PROFILE}
        mv ${ROOT}/${APP_DIR}/${WEB}/target/${WEB}.war ${ROOT}/${RELEASE}/${SERVERS}/${DIRECTORY}/${SEND}/${RELEASE_DATE}/${APP_NAME}/
    done
    echo "ifield-web build end"    
}

usage_exit() {
    echo "Usage : $0 [-n prj_name(all/web/api)] [-s release_server(dev_kajima_hirakata/prd_kajima_hirakata/prd_kmdemo)] [-d yyyymmdd]" 1>&2
    exit 1
}

#引数受け取り
while getopts n:d:s:h OPT
do
    case $OPT in
        n)
            # プロジェクト名
            PRJ_NAME=$OPTARG
            ;;
        d)
            # リリース日(yyyymmdd形式)
            RELEASE_DATE=$OPTARG
            ;;
        s)
            # リリース対象サーバ(複数の場合はカンマ区切り)
            RELEASE_SERVERS=$OPTARG
            ;;
        h)
            #ヘルプ
            usage_exit
            ;;
    esac
done

# リリース日省略時は当日
if [ "${RELEASE_DATE}" = "" ]; then
    RELEASE_DATE=`date '+%Y%m%d'`
fi

# プロジェクト名省略時は「all」
if [ "${PRJ_NAME}" = "" ]; then
    PRJ_NAME="all"
fi

if [ "${RELEASE_SERVERS}" = "" ]; then
    RELEASE_SERVERS="all"
fi

# 前準備
clean ${RELEASE_DATE} ${APP_NAME}
if [ "$PRJ_NAME" = "clean" ]; then
    echo "clean!"
    exit 0
else
    prepare ${RELEASE_DATE} ${APP_NAME}
fi

# 対象サーバ選択
if [ ! "${RELEASE_SERVERS}" = "all" ]; then
    echo "call select_server"
    select_server ${RELEASE_SERVERS}
fi

# 引数により処理切り替え
case $PRJ_NAME in
"all")
    echo "ifield all build"
    build_ifield-api
    build_ifield-web
    ;;
"api")
    echo "ifield-api only build"
    build_ifield-api
    ;;
"web")
    echo "ifield-web only build"
    build_ifield-web
    ;;
*)
    echo "プロジェクト名を正しく指定してください。"
    exit 1
esac 
