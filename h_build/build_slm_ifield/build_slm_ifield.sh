#!/bin/bash

################################################################
# 日立建機・現場管理用ビルドシェル用
################################################################

# 固有定数宣言
APP_NAME=ifield_hitachiKenki

# 定数シェル読み込み
. ../build_common/build_slm_const.sh

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
RELEASE_PRF_LIST=()

# ifield_hitachiKenki-apiのビルド
build_ifield_hitachiKenki-api() {
    cd ${API_DIR}
    git fetch
    git checkout ${TARGET_GIT_BRANCH}
    git pull origin ${TARGET_GIT_BRANCH}
    git_tag
    mvn clean package -P ${RELEASE_PRF}
    mv ${API_DIR}/target/${API_NAME}.war ${SND_DIR}/war/
}

# ifield_hitachiKenki-webのビルド
build_ifield_hitachiKenki-web() {
    cd ${WEB_DIR}
    git fetch
    git checkout ${TARGET_GIT_BRANCH}
    git pull origin ${TARGET_GIT_BRANCH}
    git_tag
    mvn clean package -P ${RELEASE_PRF_WEB}
    cp ${WEB_DIR}/target/${WEB_NAME}.war ${SND_DIR}/war/
}

# main----------------------------------------------------------------START
# 初期化
SECONDS=0
WEB_FLG=true

# プロファイルからサーバ名等を設定
set_server_env

# Mavenプロファイル切り替え(複数サーバ構成、1台構成)
if [ ${#RELEASE_SRV_LIST[@]} -gt 1 ]; then
    for i in "${!RELEASE_SRV_LIST[@]}"
    do
        no=$(($i + 1))
        RELEASE_PRF_LIST+=("${TARGET_PRF}_${no}")
    done
else
    RELEASE_PRF_LIST=(${TARGET_PRF})
fi

export RELEASE_PRF_LIST
export RELEASE_PRF_WEB=${TARGET_PRF}

for i in "${!RELEASE_SRV_LIST[@]}"
do
    RELEASE_SRV=${RELEASE_SRV_LIST[$i]}
    RELEASE_PRF=${RELEASE_PRF_LIST[$i]}
    SND_DIR=${SRV_DIR}/${RELEASE_SRV}/${SEND}/${RELEASE_DATE}/${APP_NAME_S}

    echo "Build for ${RELEASE_SRV} START"
    echo "Maven profile：${RELEASE_PRF}"
    echo "Git branch：${TARGET_GIT_BRANCH}"

    # 前準備
    prepare

    # 引数によりビルド処理切り替え
    case $PRJ_NAME in
    "all")
        echo "ifield_hitachiKenki all build"
        build_ifield_hitachiKenki-api
        if $WEB_FLG ; then
            build_ifield_hitachiKenki-web
            WEB_FLG=false
        else
            cp ${WEB_DIR}/target/${WEB_NAME}.war ${SND_DIR}/war/
        fi
	;;
    "api")
        echo "ifield_hitachiKenki-api only build"
        build_ifield_hitachiKenki-api
        ;;
    "web")
        echo "ifield_hitachiKenki-web only build"
        if $WEB_FLG ; then
            build_ifield_hitachiKenki-web
            WEB_FLG=false
        else
            cp ${WEB_DIR}/target/${WEB_NAME}.war ${SND_DIR}/war/
        fi
	;;
    "send-only")
        echo "send only"
        ;;
    *)
        echo "プロジェクト名を正しく指定してください。"
        exit 1
    esac

    # リリース先へ転送
    #rsync -avz ${SND_DIR} ${RELEASE_SRV}:~/release/
    echo "Build for ${RELEASE_SRV} E N D"
done

echo "run time:$SECONDS"
# main----------------------------------------------------------------E N D
