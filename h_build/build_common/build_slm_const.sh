#!/bin/bash

# ルートディレクトリ---------------------------------------------------------------------------------------------
export ROOT="/home/ms-user/build"
export RELEASE="release"
export APPS="apps"
export SEND="send"
export SERVERS="servers"

# リリース用サーバフォルダを設定
export SRV_DIR=${ROOT}/${SERVERS}

# ビルド用アプリフォルダを設定
export APP_DIR=${ROOT}/${APPS}

# CodeDeployのスクリプトフォルダ
export CODE_DEPLOY_SCRIPTS_DIR=~/build/tools/CodeDeploy

