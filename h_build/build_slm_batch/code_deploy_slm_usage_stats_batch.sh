#!/bin/bash

################################################################
# 日立建機・顧客管理バッチ用CodeDeployシェル
################################################################

# 固有定数宣言
# CodeDeployのアプリ名
CODE_DEPLOY_APP_NAME=slm_usage_stats_batch

# 定数シェル読み込み
. ../build_slm_com_code_deploy.sh
