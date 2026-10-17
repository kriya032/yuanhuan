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

echo "==> [2/4] 同步最新游戏到 www/index.html（内嵌引擎 + Logo）"
node -e "
const fs=require('fs');
const three=fs.readFileSync('../game/three.min.js','utf8');
const logo='data:image/jpeg;base64,'+fs.readFileSync('../game/assets/logo.jpg').toString('base64');
let html=fs.readFileSync('../game/index.html','utf8');
// 注意：必须用函数替换，否则 three.min.js 中的 \$& 会被当作替换模式导致文件损坏
html=html.replace('<script src=\"./three.min.js\"></script>', function(){ return '<script>'+three+'</scr'+'ipt>'; });
html=html.replace('var LOGO_DATA = 0;', function(){ return 'var LOGO_DATA = '+JSON.stringify(logo)+';'; });
fs.writeFileSync('www/index.html',html);
console.log('www/index.html updated:', (html.length/1024).toFixed(0)+'KB');
"

echo "==> [3/4] 安装依赖与安卓平台（首次）"
[ -d node_modules ] || npm install
[ -d platforms/android ] || cordova platform add android

echo "==> [4/4] 构建 APK"
cordova build android

echo ""
echo "✅ 构建完成！APK 位于："
echo "   platforms/android/app/build/outputs/apk/debug/app-debug.apk"
