#!/bin/bash

# リリースフォルダクリア
clean() {
    local RELEASE_DATE=$1
    local APP_NAME=$2

    for SERVER_INFO in ${!SERVER_INFOS[@]};
    do
        DIRECTORY=${SERVER_INFO}
        if [ -d ${ROOT}/${RELEASE}/${SERVERS}/${DIRECTORY}/${SEND}/${RELEASE_DATE}/${APP_NAME} ]; then
            rm -R ${ROOT}/${RELEASE}/${SERVERS}/${DIRECTORY}/${SEND}/${RELEASE_DATE}/${APP_NAME}
        fi
    done
}

# リリースフォルダ作成及びSQLファイルのコピー
prepare() {
    local RELEASE_DATE=$1
    local APP_NAME=$2

    # リリース日空欄チェック
    if [ "${RELEASE_DATE}" = "" ]; then
        echo "リリース日を指定してください。"
        exit 1
    fi

    for SERVER_INFO in ${!SERVER_INFOS[@]};
    do
        DIRECTORY=${SERVER_INFO}
        # リリースフォルダ作成
        mkdir -p ${ROOT}/${RELEASE}/${SERVERS}/${DIRECTORY}/${SEND}/${RELEASE_DATE}/${APP_NAME}
        if [ ${APP_NAME} = "ifield" ]  && [ -e {${ROOT}/${APP_DIR}/ifield-api/database/change_log/${RELEASE_DATE}/*.sql} ]; then
            # SQLファイルコピー
            mkdir -p ${ROOT}/${RELEASE}/${SERVERS}/${DIRECTORY}/${SEND}/${RELEASE_DATE}/sql
            cp -a ${ROOT}/${APP_DIR}/ifield-api/database/change_log/${RELEASE_DATE}/*.sql ${ROOT}/${RELEASE}/${SERVERS}/${DIRECTORY}/${SEND}/${RELEASE_DATE}/sql/
        fi
    done
}

# 連想配列の中身を選択されたサーバのみにする。
select_server() {
    local RELEASE_SERVERS=$1
    declare -A tmp
    TARGET_SERVER_LIST=(${RELEASE_SERVERS//,/ })

    for target_server in "${TARGET_SERVER_LIST[@]}"
    do
        TARGET_DIRECTORY=${target_server}
        TARGET_PROFILE=${SERVER_INFOS[$target_server]}

        echo "SELECTED_DIRECTORY:${TARGET_DIRECTORY}"
        echo "SELECTED_PROFILE:  ${TARGET_PROFILE}"

        if [ -n "${SERVER_INFOS[${TARGET_DIRECTORY}]}" ]; then
            tmp[${TARGET_DIRECTORY}]=${TARGET_PROFILE}
        fi
    done

    # 元のサーバ情報を一旦全削除
    for SERVER_INFO in ${!SERVER_INFOS[@]};
    do
        unset SERVER_INFOS[${SERVER_INFO}]
    done

    # 一時連想配列から復元
    for temp_info in ${!tmp[@]};
    do
        DIRECTORY=${temp_info}
        PROFILE=${tmp[$temp_info]}

        SERVER_INFOS[${DIRECTORY}]=${PROFILE}
    done
}