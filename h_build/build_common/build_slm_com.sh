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
        
        # CodeDeploy関連ファイルをコピー
        cp ${CODE_DEPLOY_SCRIPTS_DIR}/${APP_NAME_S}/appspec.yml ${SND_DIR}/
        mkdir -p ${SND_DIR}/scripts
        cp ${CODE_DEPLOY_SCRIPTS_DIR}/${APP_NAME_S}/scripts/before_install.sh ${SND_DIR}/scripts/
        cp ${CODE_DEPLOY_SCRIPTS_DIR}/${APP_NAME_S}/scripts/after_install.sh ${SND_DIR}/scripts/
    fi
}

# git tag付加
git_tag() {
    TAG_NAME=${TARGET_SERVER_SHRT}_release_${RELEASE_DATE}
    git tag -a ${TAG_NAME} -m "${RELEASE_DATE:0:4}年${RELEASE_DATE:4:2}月${RELEASE_DATE:6:2}日 ${TARGET_SERVER_NAME}環境リリース用"
    git push origin ${TAG_NAME}
}

# プロファイルからサーバ名等を設定
set_server_env() {
    case ${TARGET_PRF} in
    "slm-dev")
        export TARGET_SERVER_NAME="SLM-DEV"
        export TARGET_SERVER_SHRT="slm-dev"
        export CODE_DEPLOY_S3="slm-code-deploy-slmdev"
        export CODE_DEPLOY_GRP="SLM_DepGroup"
        export IAM_PRF="slm-dev"
        ;;
    "dev-poc")
        export TARGET_SERVER_NAME="PoC-DEV"
        export TARGET_SERVER_SHRT="poc-dev"
        export CODE_DEPLOY_S3="slm-code-deploy"
        export CODE_DEPLOY_GRP="SLM_DepGroup"
        export IAM_PRF="poc"
        ;;
    "poc")
        export TARGET_SERVER_NAME="PoC"
        export TARGET_SERVER_SHRT="poc"
        export CODE_DEPLOY_S3="slm-code-deploy"
        export CODE_DEPLOY_GRP="SLM_DepGroupPoC"
        export IAM_PRF="poc"
        ;;
    "staging")
        export TARGET_SERVER_NAME="ステージング"
        export TARGET_SERVER_SHRT="stg"
        export CODE_DEPLOY_S3="slm-code-deploy-stg"
        export CODE_DEPLOY_GRP="SLM_DepGroup"
        export IAM_PRF="staging"
        ;;
    "reheasal")
        export TARGET_SERVER_NAME="リハーサル"
        export TARGET_SERVER_SHRT="reh"
        export CODE_DEPLOY_S3="slm-code-deploy-rehea"
        export CODE_DEPLOY_GRP="SLM_DepGroupRehea"
        export IAM_PRF="prd"
        ;;
    "lt")
        export TARGET_SERVER_NAME="LT"
        export TARGET_SERVER_SHRT="lt"
        export CODE_DEPLOY_S3="slm-code-deploy-lt"
        export CODE_DEPLOY_GRP="SLM_DepGroup"
        export IAM_PRF="prd"
        ;;
    "release")
        export TARGET_SERVER_NAME="本番"
        export TARGET_SERVER_SHRT="prd"
        export CODE_DEPLOY_S3="slm-code-deploy-prd"
        export CODE_DEPLOY_GRP="SLM_DepGroup"
        export IAM_PRF="product"
        ;;
    esac
}

