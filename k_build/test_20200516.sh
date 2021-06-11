#!/bin/bash

if [ -e {/mydata/kajima_build/apps/ifield-api/database/change_log/20200630} ]; then
    echo 'exists!'
else
    echo 'not exists!'
fi
