// 《元幻》单文件构建：内嵌 three.js 引擎 + GLTFLoader + GLB 模型 + 地表贴图 + Logo
// 用法：node build-sync.js   （在 cordova/ 目录下执行，产物为 www/index.html 与 ../game/元幻-安卓单文件版.html）
const fs = require('fs');
const path = require('path');
const gameDir = path.join(__dirname, '..', 'game');

const three = fs.readFileSync(path.join(gameDir, 'three.min.js'), 'utf8');
const gltfLoader = fs.readFileSync(path.join(gameDir, 'assets', 'GLTFLoader.js'), 'utf8');
const logo = 'data:image/jpeg;base64,' + fs.readFileSync(path.join(gameDir, 'assets', 'logo.jpg')).toString('base64');
const glbM = fs.readFileSync(path.join(gameDir, 'assets', 'human_m.glb')).toString('base64');
const glbF = fs.readFileSync(path.join(gameDir, 'assets', 'woman_f.glb')).toString('base64');
const ground = 'data:image/jpeg;base64,' + fs.readFileSync(path.join(gameDir, 'assets', 'ground1k.jpg')).toString('base64');

let html = fs.readFileSync(path.join(gameDir, 'index.html'), 'utf8');

// 注意：必须用函数替换，否则 three.min.js 中的 $& 会被当作替换模式导致文件损坏
html = html.replace('<script src="./three.min.js"></script>', function () { return '<script>' + three + '</scr' + 'ipt>'; });
html = html.replace('<script src="./assets/GLTFLoader.js"></script>', function () { return '<script>' + gltfLoader + '</scr' + 'ipt>'; });
html = html.replace('var LOGO_DATA = 0;', function () { return 'var LOGO_DATA = ' + JSON.stringify(logo) + ';'; });
html = html.replace('/*__INJECT_GLB_M__*/', function () { return 'GLB_M=' + JSON.stringify(glbM) + ';'; });
html = html.replace('/*__INJECT_GLB_F__*/', function () { return 'GLB_F=' + JSON.stringify(glbF) + ';'; });
html = html.replace('/*__INJECT_GROUND__*/', function () { return 'GROUND_IMG=' + JSON.stringify(ground) + ';'; });

fs.writeFileSync(path.join(__dirname, 'www', 'index.html'), html);
fs.writeFileSync(path.join(gameDir, '元幻-安卓单文件版.html'), html);
console.log('build ok:', (html.length / 1024 / 1024).toFixed(2) + 'MB');
