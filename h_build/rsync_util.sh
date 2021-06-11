#!/bin/bash

# リリースフォルダを設定
SERVERS_DIR="~/build/servers"

# OSユーザ
OS_USER="ec2-user"

# アップロード対象ディレクトリ
TARGET_DIR="/home/${OS_USER}/release"

read -p "作業モードを入力してください。 {s(end)/r(ecv)}: " WORK_MODE
case "${WORK_MODE}" in
  [sS])
    WORK_MODE="send"
    echo "送信モードが選択されました。"
    ;;
  [rR])
    WORK_MODE="recv"
    echo "受信モードが選択されました。"
    ;;
  *) echo "作業モードが認識できませんでした。"
  exit 1
esac

read -p "作業日を入力してください。 (yyyymmdd形式 作業日省略時は当日): " WORK_DATE
if [ "${WORK_DATE}" = "" ]; then
    WORK_DATE=`date '+%Y%m%d'`
fi

read -p "作業対象サーバを入力してください。(「dev_hitachikenki_poc/rehea_hitachikenki」等): " WORK_SERVER
if [ "${WORK_SERVER}" = "" ]; then
    echo "作業対象サーバが未入力です。"
    exit 1
fi

if [ "${WORK_SERVER}" = "dev_hitachikenki_build" ]; then
    OS_USER=ms-user
    TARGET_DIR="/home/${OS_USER}/release"
    echo 
fi

if [ "${WORK_MODE}" = "recv" ]; then
  read -p "取得したいディレクトリまたはファイル名を入力してください。 : " FROM_DIR
  if [ "${FROM_DIR}" = "" ]; then
    echo "取得元ディレクトリをが未入力です。"
    exit 1
  fi
fi

if [ "${WORK_MODE}" = "send" ]; then
  # アップロード
  rsync -avz ${SERVERS_DIR}/${WORK_SERVER}/${WORK_MODE}/${WORK_DATE} ${WORK_SERVER}:${TARGET_DIR}/
else
  # ダウンロード
  rsync -avz ${WORK_SERVER}:${FROM_DIR} ${SERVERS_DIR}/${WORK_SERVER}/${WORK_MODE}/${WORK_DATE}/
fi

exit $?
