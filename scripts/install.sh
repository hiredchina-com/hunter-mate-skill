#!/usr/bin/env bash
set -e

# HunterMate CLI 安装脚本
# 用法: curl -fsSL .../install.sh | bash

REPO="hiredchina-com/hunter-mate"
INSTALL_DIR="${HOME}/.hunter-mate"
BIN_DIR="${INSTALL_DIR}/bin"

get_os() {
  case "$(uname -s)" in
    Linux*)     echo "linux";;
    Darwin*)    echo "darwin";;
    CYGWIN*|MINGW*|MSYS*) echo "windows";;
    *)          echo "unknown";;
  esac
}

get_arch() {
  case "$(uname -m)" in
    x86_64|amd64) echo "x64";;
    arm64|aarch64) echo "arm64";;
    *)            echo "unknown";;
  esac
}

OS="$(get_os)"
ARCH="$(get_arch)"

if [ "$OS" = "unknown" ] || [ "$ARCH" = "unknown" ]; then
  echo "不支持的操作系统或架构: $OS/$ARCH"
  exit 1
fi

# 获取最新 Release 版本
LATEST_TAG=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')
if [ -z "$LATEST_TAG" ]; then
  echo "无法获取最新版本"
  exit 1
fi

echo "Installing HunterMate ${LATEST_TAG} for ${OS}-${ARCH}..."

ASSET="hunter-mate-${OS}-${ARCH}.tar.gz"
URL="https://github.com/${REPO}/releases/download/${LATEST_TAG}/${ASSET}"

mkdir -p "${BIN_DIR}"
curl -fsSL "${URL}" -o "${INSTALL_DIR}/${ASSET}"
tar -xzf "${INSTALL_DIR}/${ASSET}" -C "${BIN_DIR}"
rm "${INSTALL_DIR}/${ASSET}"
chmod +x "${BIN_DIR}/hunter-mate"

# 提示加入 PATH
if [[ ":$PATH:" != *":${BIN_DIR}:"* ]]; then
  echo ""
  echo "请将以下路径加入 PATH:"
  echo "  export PATH=\"${BIN_DIR}:\$PATH\""
fi

echo ""
echo "安装完成。运行 hunter-mate --version 验证。"
