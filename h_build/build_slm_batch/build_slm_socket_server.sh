#!/bin/bash

################################################################
# 日立建機・ソケットサーバ用ビルドシェル用
# 対象：全環境共通
################################################################

# 固有定数宣言
APP_NAME=hitachiKenkiAtrackSocket
APP_NAME_S=slm_socket_server
JAR_NAME=atrackSocket.jar

# 定数シェル読み込み
. ../build_common/build_slm_const.sh

# 共通処理シェル読み込み
. ../build_common/build_slm_com.sh

# 引数共通処理実行
. ../build_common/build_slm_com_getopts.sh

# 前準備
prepare() {
    if [ -d ${SND_DIR}/jar ]; then
        rm -f ${SND_DIR}/jar/${JAR_NAME}
    else
        mkdir -p ${SND_DIR}/jar
    fi

    if [ -d ${SND_DIR}/shell ]; then
        rm -f ${SND_DIR}/shell/*.sh
    else
        mkdir -p ${SND_DIR}/shell
    fi
    #cp ${APP_DIR}/${APP_NAME}/shell/*.sh ${SND_DIR}/shell/

    # CodeDeploy関連ファイルをコピー
    cp ${CODE_DEPLOY_SCRIPTS_DIR}/${APP_NAME_S}/appspec.yml ${SND_DIR}/
    mkdir -p ${SND_DIR}/scripts
    cp ${CODE_DEPLOY_SCRIPTS_DIR}/${APP_NAME_S}/scripts/before_install.sh ${SND_DIR}/scripts/
}

# socket_serverのビルド
build_socket_server() {
    echo ${APP_DIR}/${APP_NAME}
    cd ${APP_DIR}/${APP_NAME}
    git fetch
    git checkout ${TARGET_GIT_BRANCH}
    git pull origin ${TARGET_GIT_BRANCH}
    git_tag
    ./gradlew clean jar
    cp ${APP_DIR}/${APP_NAME}/build/libs/${JAR_NAME} ${SND_DIR}/jar/
}

# main----------------------------------------------------------------START
# 初期化
SECONDS=0

# 固有定数宣言
# サーバリストを取得
export RELEASE_SRV_LIST=(`cat ../conf/server_list_${TARGET_PRF}.txt`)

for release_server in "${RELEASE_SRV_LIST[@]}"
do
    SND_DIR=${SRV_DIR}/${release_server}/${SEND}/${RELEASE_DATE}/${APP_NAME_S}
    
    # 前準備
    prepare

    # ビルド
    build_socket_server

    # リリース先へ転送
    #rsync -avz ${SND_DIR} ${release_server}:~/release/
done

echo "run time:$SECONDS"
# main----------------------------------------------------------------E N D
