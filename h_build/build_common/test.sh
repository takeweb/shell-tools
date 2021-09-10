TARGET_PRF=$1

if [ "${TARGET_PRF}" = "dev-poc" ] || [ "${TARGET_PRF}" = "poc" ]; then
    export TARGET_GIT_BRANCH="develop"
else
    export TARGET_GIT_BRANCH="master"
fi

echo ${TARGET_GIT_BRANCH}
