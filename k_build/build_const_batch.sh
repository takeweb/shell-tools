#!/bin/bash

# JDK関連
#export JAVA_HOME=/app/jdk-11.0.2
export JAVA_HOME=/app/amazon-corretto-11.0.7.10.1-linux-x64
export PATH=$PATH:$JAVA_HOME/bin

# Mavenのプロファイル
export PROFILE_BATCH_DEV="develop"  # バッチ共通・開発サーバ
export PROFILE_BATCH_PRD="release"  # バッチ共通・本番サーバ
