./build_slm_ifield.sh -p poc -d ${RELEASE_DATE}


# リリース日が当日の場合は、省略可能
./build_slm_ifield.sh -p poc
./build_slm_ifield.sh -p lt

./build_slm_ifield.sh -p lt -n api
