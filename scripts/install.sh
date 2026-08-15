#!/usr/bin/env bash
set -e

# HunterMate CLI 安装脚本(npm 渠道)
# 用法: curl -fsSL .../install.sh | bash
# 分发模型:CLI 以 npm 包 `hunter-mate` 发布,自动更新依赖 npm registry

OLD_BIN="${HOME}/.hunter-mate/bin/hunter-mate"

# 1) 前置检查:node >= 20 + npm
if ! command -v node >/dev/null 2>&1; then
  echo "✗ 未检测到 Node.js(要求 >= 20)。请先安装:https://nodejs.org/"
  exit 1
fi
NODE_MAJOR=$(node -p "process.versions.node.split('.')[0]")
if [ "$NODE_MAJOR" -lt 20 ]; then
  echo "✗ Node 版本过低(当前 $(node -v),要求 >= 20)。请先升级:https://nodejs.org/"
  exit 1
fi
if ! command -v npm >/dev/null 2>&1; then
  echo "✗ 未检测到 npm。请确认 Node.js 安装完整(npm 随 Node 附带)。"
  exit 1
fi

# 2) 旧二进制版本迁移提示(历史 GitHub Release 二进制渠道)
if [ -x "$OLD_BIN" ]; then
  echo "⚠ 检测到旧二进制安装(${OLD_BIN},已停止分发)"
  echo "  建议迁移后移除,避免 PATH 优先级冲突:"
  echo "    mv \"${OLD_BIN}\" \"${OLD_BIN}.bak\"  # 或确认 npm 版可用后 rm -rf ~/.hunter-mate/bin"
  echo ""
fi

# 3) 安装
echo "Installing hunter-mate via npm (node $(node -v))..."
npm install -g hunter-mate@latest

# 4) 验证
VERSION=$(hunter-mate --version 2>/dev/null | head -1 || true)
if [ -z "$VERSION" ]; then
  # 可能是 PATH 未包含 npm global bin
  NPM_BIN=$(npm prefix -g)/bin
  echo ""
  echo "⚠ 安装完成但 hunter-mate 不在 PATH,请将以下路径加入 PATH:"
  echo "  export PATH=\"${NPM_BIN}:\$PATH\""
else
  echo "✓ hunter-mate ${VERSION} 安装成功"
fi

echo ""
echo "后续无需手动升级:CLI 每次使用时自动检测 npm registry 并自更新。"
