#!/bin/bash

usage_exit() {
    echo "Usage : $0 [-n prj_name{all/web/api}] [-p profile{slm-dev/dev-poc/reheasal/staging/poc/release}] [-d yyyymmdd]" 1>&2
    exit 1
}

while getopts :n:p:d:b:h OPT
do
    case $OPT in
    n) # プロジェクト名
        export PRJ_NAME=$OPTARG
        ;;
    d) # リリース日(yyyymmdd形式)
        export RELEASE_DATE=$OPTARG
        ;;
    p) # Mavenプロファイル
        export TARGET_PRF=$OPTARG
        ;;
    b) # Gitのブランチ名
        export TARGET_GIT_BRANCH=$OPTARG
        ;;
    *) #ヘルプ
        usage_exit
        ;;
    esac
done

# プロジェクト名省略時は「all」
if [ "${PRJ_NAME}" = "" ]; then
    export PRJ_NAME="all"
fi

# リリース日省略時は当日
if [ "${RELEASE_DATE}" = "" ]; then
    export RELEASE_DATE=`date '+%Y%m%d'`
fi

# プロファイル
if [ "${TARGET_PRF}" = "" ]; then
    echo "プロファイルを指定してください。"
    exit 1
fi

# Gitのブランチ名 省略時は「develop」
if [ "${TARGET_GIT_BRANCH}" = "" ]; then
    if [ "${TARGET_PRF}" = "dev-poc" ] || [ "${TARGET_PRF}" = "poc" ]; then
        export TARGET_GIT_BRANCH="develop"
    else
        export TARGET_GIT_BRANCH="master" 
    fi
fi

