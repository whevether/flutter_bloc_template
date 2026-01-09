#!/bin/bash

# ================================
# Flutter 多环境构建脚本（无 flavors）
# 使用方式：
#   ./build.sh dev apk
#   ./build.sh test ios
#   ./build.sh prod apk
# ================================

ENV=$1
PLATFORM=$2

if [ -z "$ENV" ]; then
  echo "❌ 请输入环境参数：dev / test / prod"
  exit 1
fi

# 默认平台为 apk
if [ -z "$PLATFORM" ]; then
  PLATFORM="apk"
fi

# 默认配置
API_BASE_URL=""
ENABLE_LOG=true
HTTP_PORT=443
SOCKET_PORT=8002

case $ENV in
  dev)
    API_BASE_URL="http://192.168.2.133"
    HTTP_PORT=7001
    ENABLE_LOG=true
    SOCKET_PORT=8002
    ;;
  test)
    API_BASE_URL="http://192.168.2.215"
    HTTP_PORT=7001
    ENABLE_LOG=true
    SOCKET_PORT=8002
    ;;
  prod)
    API_BASE_URL="https://api.com"
    HTTP_PORT=443
    ENABLE_LOG=false
    SOCKET_PORT=8002
    ;;
  *)
    echo "❌ 未知环境：$ENV（仅支持 dev / test / prod）"
    exit 1
    ;;
esac

echo "==============================="
echo "🚀 开始构建环境：$ENV"
echo "📦 构建平台：$PLATFORM"
echo "🌐 API 地址：$API_BASE_URL"
echo "📝 日志开关：$ENABLE_LOG"
echo "==============================="

# ================================
# 构建 APK
# ================================
if [ "$PLATFORM" = "apk" ]; then
  flutter build apk \
    --dart-define=ENV=$ENV \
    --dart-define=API_BASE_URL=$API_BASE_URL \
    --dart-define=ENABLE_LOG=$ENABLE_LOG

  echo "🎉 APK 构建完成：$ENV"
  exit 0
fi

# ================================
# 构建 iOS
# ================================
if [ "$PLATFORM" = "ios" ]; then
  flutter build ios \
    --release \
    --no-codesign \
    --dart-define=ENV=$ENV \
    --dart-define=API_BASE_URL=$API_BASE_URL \
    --dart-define=ENABLE_LOG=$ENABLE_LOG

  echo "🎉 iOS 构建完成（未签名）：$ENV"
  echo "📌 你可以用 Xcode 进行签名导出 IPA"
  exit 0
fi

echo "❌ 未知平台：$PLATFORM（仅支持 apk / ios）"
exit 1
