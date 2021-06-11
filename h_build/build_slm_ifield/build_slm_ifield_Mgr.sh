#!/bin/bash

################################################################
# 日立建機・本社管理用ビルドシェル用
################################################################

# 定数シェル読み込み
. ../build_common/build_slm_const.sh

# 固有定数宣言
APP_NAME=ifield_hitachiKenki-Mgr

# WEB用定数シェル読み込み
. ../build_common/build_slm_const_web.sh

# 共通処理シェル読み込み
. ../build_common/build_slm_com.sh

# 引数共通処理実行
. ../build_common/build_slm_com_getopts.sh

# 固有定数宣言
# サーバリストを取得
export RELEASE_SRV_LIST=(`cat ../conf/server_list_${TARGET_PRF}.txt`)

# Mavenプロファイル
export RELEASE_PRF=${TARGET_PRF}

# ifield_hitachiKenki-Mgr-apiのビルド
build_ifield_hitachiKenki-Mgr-api() {
    cd ${API_DIR}
    git fetch
    git checkout ${TARGET_GIT_BRANCH}
    git pull origin ${TARGET_GIT_BRANCH}
    git_tag
    mvn clean package -P ${RELEASE_PRF}
    mv ${API_DIR}/target/${API_NAME}.war ${SND_DIR}/war/
}

# ifield_hitachiKenki-Mgr-webのビルド
build_ifield_hitachiKenki-Mgr-web() {
    cd ${WEB_DIR}
    git fetch
    git checkout ${TARGET_GIT_BRANCH}
    git pull origin ${TARGET_GIT_BRANCH}
    git_tag
    mvn clean package
    cp ${WEB_DIR}/target/${WEB_NAME}.war ${SND_DIR}/war/
}

# main----------------------------------------------------------------START
# 初期化
SECONDS=0
WEB_FLG=true

for RELEASE_SRV in ${RELEASE_SRV_LIST[@]}
do
    SND_DIR=${SRV_DIR}/${RELEASE_SRV}/${SEND}/${RELEASE_DATE}

    echo "Build for ${RELEASE_SRV} start"

    # 前準備
    prepare

    # 引数によりビルド処理切り替え
    case $PRJ_NAME in
    "all")
        echo "ifield_hitachiKenki-Mgr all build"
        build_ifield_hitachiKenki-Mgr-api
        build_ifield_hitachiKenki-Mgr-web
        if $WEB_FLG ; then
            build_ifield_hitachiKenki-Mgr-web
            WEB_FLG=false
        else
            cp ${WEB_DIR}/target/${WEB_NAME}.war ${SND_DIR}/war/
        fi
        ;;
    "api")
        echo "ifield_hitachiKenki-Mgr-api only build"
        build_ifield_hitachiKenki-Mgr-api
        ;;
    "web")
        echo "ifield_hitachiKenki-Mgr-web only build"
        if $WEB_FLG ; then
            build_ifield_hitachiKenki-Mgr-web
            WEB_FLG=false
        else
            cp ${WEB_DIR}/target/${WEB_NAME}.war ${SND_DIR}/war/
        fi
        ;;
    *)
        echo "プロジェクト名を正しく指定してください。"
        exit 1
    esac

    # リリース先へ転送
    rsync -avz ${SND_DIR} ${RELEASE_SRV}:~/release/

    echo "Build for ${RELEASE_SRV} e n d"
done

echo "run time:$SECONDS"
# main----------------------------------------------------------------E N D
