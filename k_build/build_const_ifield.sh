#!/bin/bash

# アプリケーション名
export APP_NAME="ifield"
export WEB="ifield-web"
export API="ifield-api"

# リリース対象サーバ
export RELEASE_SERVER="all"

# JDK関連
#export JAVA_HOME=/app/jdk1.7.0_80
export JAVA_HOME=/app/amazon-corretto-8.252.09.1-linux-x64
export PATH=$PATH:$JAVA_HOME/bin
export MAVEN_OPTS="-Dhttps.protocols=TLSv1.2"
export JAVA_OPTS="-Djava.net.preferIPv4Stack=true"
