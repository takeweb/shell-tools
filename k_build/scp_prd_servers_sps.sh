#!/bin/bash

# 定数シェル読み込み
. build_const.sh

# OSユーザ、ホームディレクトリを設定
OS_USER="ec2-user"
TARGET_DIR=/home/${OS_USER}/${RELEASE}

# 対象サーバ
TARGET_SERVER="prd_kajima_sps"

# リリース日を設定
RELEASE_DATE=$1

# リリースモジュールを設定
RELEASE_MODULE=$2

# 本番_日下川AWS
scp -r ${KAJIMA_RELEASE}/${TARGET_SERVER}/${SEND}/${RELEASE_DATE}/${RELEASE_MODULE} ${OS_USER}@${TARGET_SERVER}:/${TARGET_DIR}/${RELEASE_DATE}/

