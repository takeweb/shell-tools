#!/bin/bash

# APPルートルートディレクトリ
export APP_DIR="apps"

# 対象サーバ名配列
# 検証サーバ-------------------------------------------------------------------------------------------
# dev_kajima_hirakata     検証サーバ・新名神枚方
# dev_kajima_hirakata_new 検証サーバ・新名神枚方NEW
# dev_kajima_gaikanramp   検証サーバ・東京外環中央JCT
#export ARRY_DEV_SERVERS=("dev_kajima_hirakata" "dev_kajima_hirakata_new" "dev_kajima_gaikanramp")
export ARRY_DEV_SERVERS=("dev_kajima_hirakata")

# 本番サーバ-------------------------------------------------------------------------------------------
# prd_kajima_hirakata     本番サーバ・新名神枚方
# prd_kajima_kmdemo       本番サーバ・見える化デモ環境
export ARRY_PRD_SERVERS=("prd_kajima_hirakata" "prd_kajima_kmdemo")

# リリースディレクトリとMavenプロファイルのペア
declare -A SERVER_INFOS;
export SERVER_INFOS=(
  [${ARRY_DEV_SERVERS[0]}]="develop_hirakata"      # 検証サーバ・新名神枚方
  [${ARRY_PRD_SERVERS[0]}]="release_hirakata"      # 本番サーバ・新名神枚方
  [${ARRY_PRD_SERVERS[1]}]="release_kmdemo"        # 本番サーバ・見える化デモ環境
)
