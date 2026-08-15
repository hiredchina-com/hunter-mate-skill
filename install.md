# HunterMate CLI 安装指南

## 系统要求

- Node.js >= 20(含 npm)
- macOS 11+ / Linux / Windows WSL2
- Chrome 浏览器(用于扩展)

## 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/hiredchina-com/hunter-mate-skill/main/scripts/install.sh | bash
```

脚本会检查 Node 版本并通过 npm 安装;也可直接手动安装:

```bash
npm install -g hunter-mate@latest
```

## 验证安装

```bash
hunter-mate --version
hunter-mate status
```

## 登录

```bash
hunter-mate login
```

按提示打开浏览器完成 OAuth 设备码登录。

## 安装浏览器扩展

```bash
hunter-mate extension install
```

这会打开扩展所在文件夹。然后:

1. 打开 Chrome,访问 `chrome://extensions/`
2. 开启右上角"开发者模式"
3. 点击"加载已解压的扩展程序"
4. 选择刚才打开的文件夹中的 `extension` 目录
5. 回到终端运行 `hunter-mate extension check` 验证连接

## 卸载

```bash
npm uninstall -g hunter-mate
```

## 常见问题

### Q: npm 安装失败/网络受限?
A: 配置 npm 镜像(`npm config set registry https://registry.npmmirror.com`)后重试;开发调试场景参见仓库文档的软链模式。

### Q: 旧二进制版本(~/.hunter-mate/bin)如何迁移?
A: 该渠道已停止分发。安装 npm 版后确认 `command -v hunter-mate` 指向 npm global bin,再移除 `~/.hunter-mate/bin`。

### Q: 如何升级?
A: 无需手动升级——CLI 每次使用时自动检测 npm registry 最新版并自更新(下一条命令生效);也可手动 `npm install -g hunter-mate@latest` 或 `hunter-mate update --apply`。

### Q: 登录后 Token 存在哪里?
A: macOS 存 Keychain,Windows 存 Credential Manager,Linux 存 secret-service/libsecret。

### Q: 扩展无法连接?
A: 确保本地 Server 已启动(`hunter-mate status` 显示 server: running),并检查扩展 ID 是否匹配。
