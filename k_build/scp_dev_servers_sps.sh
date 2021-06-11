#!/bin/bash

# 定数シェル読み込み
. build_const.sh

# OSユーザ、ホームディレクトリを設定
OS_USER="root"
TARGET_DIR=/${OS_USER}/${RELEASE}

# 対象サーバ
TARGET_SERVER="dev_kajima_sps_vm"

#リリース日を設定
RELEASE_DATE=$1

#リリースモジュールを設定
RELEASE_MODULE=$2

#検証_日下川AWS
#scp -r -i ~/.ssh/dev_kajima_sps-keypair.pem $kajima_release/dev_kajima_sps/$RELEASE_DATE ec2-user@dev_kajima_sps:/home/ec2-user/release/

#検証_日下川社内VM
scp -r ${KAJIMA_RELEASE}/${TARGET_SERVER}/${SEND}/${RELEASE_DATE}/${RELEASE_MODULE} ${OS_USER}@${TARGET_SERVER}:/${TARGET_DIR}/${RELEASE_DATE}/

