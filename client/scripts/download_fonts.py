#!/usr/bin/env python3
"""
字体下载脚本
用于下载中文字体文件到本地，避免运行时网络依赖
"""

import os
import requests
import zipfile
from pathlib import Path

def create_font_directories():
    """创建字体目录"""
    font_dirs = [
        'assets/fonts/noto_sans_sc',
        'assets/fonts/source_han_sans_sc'
    ]
    
    for dir_path in font_dirs:
        Path(dir_path).mkdir(parents=True, exist_ok=True)
        print(f"创建目录: {dir_path}")

def download_noto_sans_sc():
    """下载Noto Sans SC字体"""
    print("正在下载 Noto Sans SC 字体...")
    
    # Noto Sans SC 字体的直接下载链接（来自GitHub）
    fonts = {
        'NotoSansSC-Regular.ttf': 'https://github.com/googlefonts/noto-cjk/raw/main/Sans/OTF/SimplifiedChinese/NotoSansCJKsc-Regular.otf',
        'NotoSansSC-Medium.ttf': 'https://github.com/googlefonts/noto-cjk/raw/main/Sans/OTF/SimplifiedChinese/NotoSansCJKsc-Medium.otf',
        'NotoSansSC-Bold.ttf': 'https://github.com/googlefonts/noto-cjk/raw/main/Sans/OTF/SimplifiedChinese/NotoSansCJKsc-Bold.otf',
    }
    
    for filename, url in fonts.items():
        try:
            response = requests.get(url, timeout=30)
            response.raise_for_status()
            
            file_path = f'assets/fonts/noto_sans_sc/{filename}'
            with open(file_path, 'wb') as f:
                f.write(response.content)
            print(f"下载完成: {filename}")
            
        except Exception as e:
            print(f"下载失败 {filename}: {e}")

def download_source_han_sans():
    """下载思源黑体"""
    print("正在下载 Source Han Sans SC 字体...")
    
    # 思源黑体的下载链接
    fonts = {
        'SourceHanSansSC-Regular.otf': 'https://github.com/adobe-fonts/source-han-sans/raw/release/OTF/SimplifiedChinese/SourceHanSansSC-Regular.otf',
        'SourceHanSansSC-Medium.otf': 'https://github.com/adobe-fonts/source-han-sans/raw/release/OTF/SimplifiedChinese/SourceHanSansSC-Medium.otf',
        'SourceHanSansSC-Bold.otf': 'https://github.com/adobe-fonts/source-han-sans/raw/release/OTF/SimplifiedChinese/SourceHanSansSC-Bold.otf',
    }
    
    for filename, url in fonts.items():
        try:
            response = requests.get(url, timeout=30)
            response.raise_for_status()
            
            file_path = f'assets/fonts/source_han_sans_sc/{filename}'
            with open(file_path, 'wb') as f:
                f.write(response.content)
            print(f"下载完成: {filename}")
            
        except Exception as e:
            print(f"下载失败 {filename}: {e}")

def main():
    """主函数"""
    print("开始下载中文字体文件...")
    print("这将帮助您的应用在中国大陆地区正常显示中文字体")
    print("-" * 50)
    
    # 创建目录
    create_font_directories()
    
    # 下载字体
    download_noto_sans_sc()
    download_source_han_sans()
    
    print("-" * 50)
    print("字体下载完成！")
    print("请运行 'flutter pub get' 来应用字体配置")

if __name__ == "__main__":
    main()
