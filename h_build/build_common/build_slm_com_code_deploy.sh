#!/bin/bash

################################################################
# 日立建機・WEB用CodeDeployシェル用
################################################################

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

# DeployGroup用リスト
DEPLOY_GROUP_LIST=()

# CodeDeploy zipファイルを作成、S3へ転送
deploy_push() {
    no=$1
    aws deploy push --application-name ${CODE_DEPLOY_APP_NAME} --s3-location s3://${CODE_DEPLOY_S3}/${TARGET_SERVER_SHRT}_release${no}_${RELEASE_DATE}.zip --ignore-hidden-files --profile ${IAM_PRF}
}

# CodeDeploy Deploy作成
create_deployment() {
    no=$1
    aws deploy create-deployment --application-name ${CODE_DEPLOY_APP_NAME} --deployment-config-name CodeDeployDefault.OneAtATime --deployment-group-name ${CODE_DEPLOY_GRP} --s3-location bucket=${CODE_DEPLOY_S3},bundleType=zip,key=${TARGET_SERVER_SHRT}_release${no}_${RELEASE_DATE}.zip --file-exists-behavior OVERWRITE --description "${RELEASE_DATE:0:4}年${RELEASE_DATE:4:2}月${RELEASE_DATE:6:2}日 ${TARGET_SERVER_NAME}環境リリース用" --profile ${IAM_PRF}
}

# main----------------------------------------------------------------START
# 初期化
SINGLE_FLG=false

# プロファイルからサーバ名等を設定(CODE_DEPLOY_S3、CODE_DEPLOY_GRP、IAM_PRF)
set_server_env

# DeployGroup切り替え(複数サーバ構成、1台構成)
if [ ${#RELEASE_SRV_LIST[@]} -gt 1 ]; then
    for i in "${!RELEASE_SRV_LIST[@]}"
    do
        no=$(($i + 1))
        DEPLOY_GROUP_LIST+=("${CODE_DEPLOY_GRP}_${no}")
    done
else
    DEPLOY_GROUP_LIST=(${CODE_DEPLOY_GRP})
    SINGLE_FLG=true
fi

export DEPLOY_GROUP_LIST

for i in "${!RELEASE_SRV_LIST[@]}"
do
    if "${SINGLE_FLG}"; then
        no=""
    else
        no=_$(($i + 1))
    fi
    RELEASE_SRV=${RELEASE_SRV_LIST[$i]}
    SND_DIR=${SRV_DIR}/${RELEASE_SRV}/${SEND}/${RELEASE_DATE}/${CODE_DEPLOY_APP_NAME}
    CODE_DEPLOY_GRP=${DEPLOY_GROUP_LIST[$i]}
    echo "CodeDeploy for ${RELEASE_SRV} START"

    # 対象ディレクトリへ移動
    cd ${SND_DIR}
    
    # CodeDeploy zipファイルを作成、S3へ転送
    deploy_push ${no} 
    
    # CodeDeploy Deploy作成
    create_deployment ${no}

    echo "CodeDeploy for ${RELEASE_SRV} E N D"
done

echo "run time:$SECONDS"
# main----------------------------------------------------------------E N D
