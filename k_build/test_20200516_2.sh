#!/bin/bash

# 土木専用定数シェル読み込み
. build_const_dbk.sh

declare -A tmp
TARGET_SERVERS="dev_kajima_hirakata,prd_kajima_hirakata"
TARGET_SERVER_LIST=(${TARGET_SERVERS//,/ })

# リリース対象サーバが「all」以外の場合、連想配列の中身を対象サーバのみにする。
if [ ! "${RELEASE_SERVER}" = "all" ]; then
    for target_server in "${TARGET_SERVER_LIST[@]}"
    do
        TARGET_DIRECTORY=${target_server}
        TARGET_PROFILE=${SERVER_INFOS[$target_server]}

        echo "SELECTED_DIRECTORY:${TARGET_DIRECTORY}"
        echo "SELECTED_PROFILE:  ${TARGET_PROFILE}"

        if [ -n "${SERVER_INFOS[${TARGET_DIRECTORY}]}" ]; then
            tmp[${TARGET_DIRECTORY}]=${TARGET_PROFILE}
        fi
    done
fi

for SERVER_INFO in ${!SERVER_INFOS[@]};
do
    DIRECTORY=${SERVER_INFO}
    PROFILE=${SERVER_INFOS[$SERVER_INFO]}

    unset SERVER_INFOS[${DIRECTORY}]
done

for temp_info in ${!tmp[@]};
do
    DIRECTORY=${temp_info}
    PROFILE=${tmp[$temp_info]}

    SERVER_INFOS[${DIRECTORY}]=${PROFILE}
done

for SERVER_INFO in ${!SERVER_INFOS[@]};
do
    DIRECTORY=${SERVER_INFO}
    PROFILE=${SERVER_INFOS[$SERVER_INFO]}

    echo "AFTER_DIRECTORY:${DIRECTORY}"
    echo "AFTER_PROFILE:  ${PROFILE}"
done