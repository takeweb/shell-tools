#!/bin/bash

# 実行シェルのコピー
copy_shell() {
    echo ${APP_NAME}" copy shell start"

    # 各サーバ用コピー
    for SERVER_INFO in ${!SERVER_INFOS[@]};
    do
        DIRECTORY=${SERVER_INFO}
        echo "DIRECTORY = ${DIRECTORY}"

        if [ -e ${ROOT}/${APP_DIR}/${APP_NAME}/*.sh ]; then
            cp -a ${ROOT}/${APP_DIR}/${APP_NAME}/*.sh ${ROOT}/${RELEASE}/${SERVERS}/${DIRECTORY}/${SEND}/${RELEASE_DATE}/${APP_NAME}/
        fi
    done

    echo ${APP_NAME}" copy shell e n d"
}

# ライブラリのコピー
copy_libs() {
    echo ${APP_NAME}" copy libs start"

    # 各サーバ用コピー
    for SERVER_INFO in ${!SERVER_INFOS[@]};
    do
        DIRECTORY=${SERVER_INFO}
        echo "DIRECTORY = ${DIRECTORY}"

        cp -R ${ROOT}/${APP_DIR}/${APP_NAME}/target/lib ${ROOT}/${RELEASE}/${SERVERS}/${DIRECTORY}/${SEND}/${RELEASE_DATE}/${APP_NAME}/
    done

    echo ${APP_NAME}" copy libs e n d"
}