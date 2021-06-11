#!/bin/bash

################################################################
# 日立建機・顧客管理バッチ用ビルドシェル用
# 対象：全環境共通
################################################################

# 定数シェル読み込み
. ../build_common/build_slm_const.sh

# 共通処理シェル読み込み
. ../build_common/build_slm_com.sh

# 引数共通処理実行
. ../build_common/build_slm_com_getopts.sh

# 固有定数宣言
APP_NAME=ifield_hitachiKenki_usage_stats_batch
JAR_NAME=usageStatsBatch.jar
ORG_JAR_NAME=slm_usage_stats_batch-jar-with-dependencies.jar

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
    cp ${APP_DIR}/${APP_NAME}/shell/*.sh ${SND_DIR}/shell/
}

# ifield_hitachiKenki_usage_stats_batchのビルド
build_usage_stats_batch() {
    cd ${APP_DIR}/${APP_NAME}
    git fetch
    git checkout ${TARGET_GIT_BRANCH}
    git pull origin ${TARGET_GIT_BRANCH}
    git_tag
    mvn clean package -P ${RELEASE_PRF}
    cp ${APP_DIR}/${APP_NAME}/target/${ORG_JAR_NAME} ${SND_DIR}/jar/${JAR_NAME}
}

# main----------------------------------------------------------------START
# 初期化
SECONDS=0

# 固有定数宣言
# サーバリストを取得
if [ "${TARGET_PRF}" = "release" ]; then
    export RELEASE_SRV_LIST=(`cat ../conf/server_list_batch_${TARGET_PRF}.txt`)
else
    export RELEASE_SRV_LIST=(`cat ../conf/server_list_${TARGET_PRF}.txt`)
fi

# プロファイル設定
RELEASE_PRF=${TARGET_PRF}

for release_server in "${RELEASE_SRV_LIST[@]}"
do
    SND_DIR=${SRV_DIR}/${release_server}/${SEND}/${RELEASE_DATE}
    
    # 前準備
    prepare

    # ビルド
    build_usage_stats_batch

    # リリース先へ転送
    rsync -avz ${SND_DIR} ${release_server}:~/release/
done

echo "run time:$SECONDS"
# main----------------------------------------------------------------E N D
