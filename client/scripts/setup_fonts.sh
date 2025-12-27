#!/bin/bash

# 字体设置脚本
# 为Flutter应用下载和配置中文字体

echo "正在设置中文字体..."

# 创建字体目录
mkdir -p assets/fonts/noto_sans_sc
mkdir -p assets/fonts/source_han_sans_sc

echo "字体目录创建完成"

# 提示用户下载字体
echo ""
echo "请手动下载以下字体文件到对应目录："
echo ""
echo "Noto Sans SC 字体 (下载到 assets/fonts/noto_sans_sc/):"
echo "1. NotoSansSC-Regular.ttf"
echo "2. NotoSansSC-Medium.ttf" 
echo "3. NotoSansSC-Bold.ttf"
echo ""
echo "下载地址："
echo "- GitHub: https://github.com/googlefonts/noto-cjk/tree/main/Sans/OTF/SimplifiedChinese"
echo "- 或使用国内镜像: https://gitee.com/mirrors/noto-cjk"
echo ""
echo "Source Han Sans SC 字体 (可选，下载到 assets/fonts/source_han_sans_sc/):"
echo "1. SourceHanSansSC-Regular.otf"
echo "2. SourceHanSansSC-Medium.otf"
echo "3. SourceHanSansSC-Bold.otf"
echo ""
echo "下载地址："
echo "- GitHub: https://github.com/adobe-fonts/source-han-sans/tree/release/OTF/SimplifiedChinese"
echo ""
echo "下载完成后，运行 'flutter pub get' 来应用字体配置"
