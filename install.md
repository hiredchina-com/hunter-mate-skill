# HunterMate CLI 安装指南

## 系统要求

- macOS 11+ / Linux / Windows WSL2
- 网络可访问 GitHub
- Chrome 浏览器(用于扩展)

## 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/hiredchina-com/hunter-mate-skill/main/scripts/install.sh | bash
```

安装完成后,建议重启终端或执行:

```bash
export PATH="$HOME/.hunter-mate/bin:$PATH"
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
2. 开启右上角“开发者模式”
3. 点击“加载已解压的扩展程序”
4. 选择刚才打开的文件夹中的 `extension` 目录
5. 回到终端运行 `hunter-mate extension check` 验证连接

## 卸载

```bash
rm -rf ~/.hunter-mate
# 同时从 PATH 中移除 $HOME/.hunter-mate/bin
```

## 常见问题

### Q: curl 安装脚本失败?
A: 检查网络是否可访问 GitHub;或手动到 [hunter-mate Releases](https://github.com/hiredchina-com/hunter-mate/releases) 下载对应平台二进制。

### Q: 登录后 Token 存在哪里?
A: macOS 存 Keychain,Windows 存 Credential Manager,Linux 存 secret-service/libsecret。

### Q: 扩展无法连接?
A: 确保本地 Server 已启动(`hunter-mate status` 显示 server: running),并检查扩展 ID 是否匹配。
