#!/bin/bash

usage_exit() {
    echo "Usage : $0 [-m mode(send/recv)] [-s server(dev_kajima_sps_vm/prd_kajima_sps)] [-d yyyymmdd]" 1>&2
    exit 1
}

# 引数無し対策
ARG=$1
if [ "$ARG" = "" ]; then
    usage_exit
    exit 1
fi

#引数受け取り
while getopts m:d:s:f:w:h OPT
do
    case $OPT in
      m)
        # 作業モード(send/recv)を設定
        WORK_MODE=$OPTARG
        if [ "$WORK_MODE" = "" ]; then
          echo "作業モード(send/recv)を指定してください。"
          exit 1
        fi
        ;;
      d)
        # 作業日(yyyymmdd形式)
        WORK_DATE=$OPTARG
        ;;
      s)
        # 作業対象サーバ
        WORK_SERVER=$OPTARG
        ;;
      f)
        # 取得元ディレクトリ
        FROM_DIR=$OPTARG
        ;;
      w)
        # 作業対象ディレクトリ
        WORK_DIR=$OPTARG
        ;;
      h)
        #ヘルプ
        usage_exit
        ;;
      *)
        #ヘルプ
        usage_exit
        ;;
    esac
done

# 作業日省略時は当日
if [ "${WORK_DATE}" = "" ]; then
    WORK_DATE=`date '+%Y%m%d'`
fi

if [ "${WORK_MODE}" = "recv" ]; then
  if [ "${FROM_DIR}" = "" ]; then
    echo "取得元を指定してください。"
    exit 1
  fi
fi

#リリース日フォルダを設定
kajima_release="/mydata/kajima_build/release/servers"

#OSユーザ
os_user="root"

#対象ディレクトリ
target_dir="/root/release"

#AWS対応
if [ "${WORK_SERVER}" = "prd_kajima_sps" ]; then
  os_user="ec2-user"
  target_dir="/home/${os_user}/release"
fi

if [ "${WORK_MODE}" = "send" ]; then
  #アップロード
  scp -r ${kajima_release}/${WORK_SERVER}/${WORK_MODE}/${WORK_DATE}/${WORK_DIR} ${os_user}@${WORK_SERVER}:${target_dir}/${WORK_DATE}
else
  #ダウンロード
  if [ ! -d ${kajima_release}/${WORK_SERVER}/${WORK_MODE}/${WORK_DATE}/${WORK_DIR} ]; then
    mkdir -p ${kajima_release}/${WORK_SERVER}/${WORK_MODE}/${WORK_DATE}/${WORK_DIR}
  fi
  scp -r ${os_user}@${WORK_SERVER}:${FROM_DIR} ${kajima_release}/${WORK_SERVER}/${WORK_MODE}/${WORK_DATE}/${WORK_DIR}
fi
