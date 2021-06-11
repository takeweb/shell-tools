#!/bin/bash

################################################################
# 日立建機・日立建機管理用ビルドシェル用
################################################################

# 定数シェル読み込み
. ../build_common/build_slm_const.sh

# 固有定数宣言
APP_NAME=ifield_hitachiKenki-Admin

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

# ifield_hitachiKenki-Admin-apiのビルド
build_ifield_hitachiKenki-Admin-api() {
    cd ${API_DIR}
    git fetch
    git checkout ${TARGET_GIT_BRANCH}
    git pull origin ${TARGET_GIT_BRANCH}
    git_tag	
    mvn clean package -P ${RELEASE_PRF}
    mv ${API_DIR}/target/${API_NAME}.war ${SND_DIR}/war/
}

# ifield_hitachiKenki-Admin-webのビルド
build_ifield_hitachiKenki-Admin-web() {
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
    echo "Build for ${RELEASE_SRV} start"
    SND_DIR=${SRV_DIR}/${RELEASE_SRV}/${SEND}/${RELEASE_DATE}

    # 前準備
    prepare

    # 引数によりビルド処理切り替え
    case $PRJ_NAME in
    "all")
        echo "ifield_hitachiKenki-Admin all build"
        build_ifield_hitachiKenki-Admin-api
        build_ifield_hitachiKenki-Admin-web
        if $WEB_FLG ; then
            build_ifield_hitachiKenki-Admin-web
            WEB_FLG=false
        else
            cp ${WEB_DIR}/target/${WEB_NAME}.war ${SND_DIR}/war/
        fi
        ;;
    "api")
        echo "ifield_hitachiKenki-Admin-api only build"
        build_ifield_hitachiKenki-Admin-api
        ;;
    "web")
        echo "ifield_hitachiKenki-Admin-web only build"
        if $WEB_FLG ; then
            build_ifield_hitachiKenki-Admin-web
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

# main----------------------------------------------------------------E N D
