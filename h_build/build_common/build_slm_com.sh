#!/bin/bash

# 前準備
prepare() {
    if [ -d ${SND_DIR}/war ]; then
        case $PRJ_NAME in
        "all")
            rm -f ${SND_DIR}/war/${API_NAME}.war
            rm -f ${SND_DIR}/war/${WEB_NAME}.war
            ;;
        "api")
            rm -f ${SND_DIR}/war/${API_NAME}.war
            ;;
        "web")
            rm -f ${SND_DIR}/war/${WEB_NAME}.war
            ;;
        *)
            echo "プロジェクト名を正しく指定してください。"
            exit 1
        esac
    else
        mkdir -p ${SND_DIR}/war
    fi
}

# git tag付加
git_tag() {
    case ${TARGET_PRF} in
    "slm-dev")
        export TARGET_SERVER_NAME="SLM-DEV"
        export TARGET_SERVER_SHRT="slm-dev"
        ;;
    "dev-poc")
        export TARGET_SERVER_NAME="PoC-DEV"
        export TARGET_SERVER_SHRT="poc-dev"
        ;;
    "poc")
        export TARGET_SERVER_NAME="PoC"
        export TARGET_SERVER_SHRT="poc"
        ;;
    "staging")
        export TARGET_SERVER_NAME="ステージング"
        export TARGET_SERVER_SHRT="stg"
        ;;
    "reheasal")
        export TARGET_SERVER_NAME="リハーサル"
        export TARGET_SERVER_SHRT="reh"
        ;;
    "lt")
        export TARGET_SERVER_NAME="LT"
        export TARGET_SERVER_SHRT="lt"
        ;;
    "release")
        export TARGET_SERVER_NAME="本番"
        export TARGET_SERVER_SHRT="prd"
        ;;
    esac

    TAG_NAME=${TARGET_SERVER_SHRT}_release_${RELEASE_DATE}
    git tag -a ${TAG_NAME} -m "${RELEASE_DATE:0:4}年${RELEASE_DATE:4:2}月${RELEASE_DATE:6:2}日 ${TARGET_SERVER_NAME}環境リリース用"
    git push origin ${TAG_NAME}
}

