#!/usr/bin/env bash
# 《元幻》Cordova 一键构建脚本
# 用法：在有 Node.js + JDK17 + Android SDK 的电脑上执行  bash build.sh
set -e
cd "$(dirname "$0")"

echo "==> [1/4] 检查环境"
command -v node >/dev/null || { echo "缺少 Node.js，请先安装"; exit 1; }
command -v cordova >/dev/null || {
  echo "==> 安装 Cordova CLI"
  npm install -g cordova
}

echo "==> [2/4] 同步最新游戏到 www/index.html（内嵌引擎 + GLTFLoader + GLB 模型 + 贴图 + Logo）"
node build-sync.js

echo "==> [3/4] 安装依赖与安卓平台（首次）"
[ -d node_modules ] || npm install
[ -d platforms/android ] || cordova platform add android

echo "==> [4/4] 构建 APK"
cordova build android

echo ""
echo "✅ 构建完成！APK 位于："
echo "   platforms/android/app/build/outputs/apk/debug/app-debug.apk"
