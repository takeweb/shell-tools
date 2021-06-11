#!/bin/bash

# APPルートディレクトリ--------------------------------------------------------------------------------------------------
export APP_DIR="apps_sps"

# 対象サーバ名配列
# 検証サーバ-------------------------------------------------------------------------------------------
# dev_kajima_sps          検証サーバ(ＡＷＳ)・日下川放水路
# dev_kajima_sps_vm       検証サーバ(社内VM)・日下川放水路
export ARRY_DEV_SERVERS=("dev_kajima_sps_vm")

# 本番サーバ-------------------------------------------------------------------------------------------
# prd_kajima_sps          本番サーバ・日下川放水路
export ARRY_PRD_SERVERS=("prd_kajima_sps")

# リリースディレクトリ・Mavenプロファイルのペア
declare -A SERVER_INFOS;
export SERVER_INFOS=(
  [${ARRY_DEV_SERVERS[0]}]="develop_sps_vm"}
  [${ARRY_PRD_SERVERS[1]}]="release_sps"}
)
