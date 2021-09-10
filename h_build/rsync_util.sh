#!/bin/bash

# リリースフォルダを設定
SERVERS_DIR="/home/ms-user/build/servers"

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

echo "作業対象サーバを入力してください。"
#1) dev_hitachikenki_slm
#2) dev_hitachikenki_poc
#3) dev_hitachikenki_build
#4) poc_hitachikenki_1
#5) poc_hitachikenki_2
#6) stg_hitachikenki_1
#7) stg_hitachikenki_2
#8) prd_hitachikenki_1
#9) prd_hitachikenki_2
#10) prd_hitachikenki_3
#11) prd_hitachikenki_4
#12) prd_hitachikenki_5
#13) prd_hitachikenki_6
#14) prd_hitachikenki_7
#15) prd_hitachikenki_8
select WORK_SERVER in dev_hitachikenki_slm dev_hitachikenki_poc dev_hitachikenki_build poc_hitachikenki_1 poc_hitachikenki_2 stg_hitachikenki_1 stg_hitachikenki_2 prd_hitachikenki_1 prd_hitachikenki_2 prd_hitachikenki_3 prd_hitachikenki_4 prd_hitachikenki_5 prd_hitachikenki_6 prd_hitachikenki_7 prd_hitachikenki_8
do
    echo "作業対象サーバは$WORK_SERVERです。"
    break
done

if [ "${WORK_SERVER}" = "" ]; then
    echo "作業対象サーバが未入力です。"
    exit 1
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
