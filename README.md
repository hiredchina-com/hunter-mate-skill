# HunterMate Skill

HunterMate 是面向猎头顾问的 AI Agent 数据助手。本仓库是**公开 Skill**,可直接在 Trae、Workbuddy、Claude Code 等 Agent 工具中通过 GitHub 地址订阅。

订阅后,Agent 会自动:
1. 安装 `hunter-mate` CLI
2. 完成用户认证
3. 通过 CLI 访问 HiredChina 人才/客户/职位数据服务
4. 在浏览器中录制简历页面并解析人才信息

## 快速开始

在支持 Skill 的 Agent 工具中输入:

```
安装并使用 hunter-mate
```

Agent 会读取 `SKILL.md` 并完成后续步骤。

## 仓库结构

```
.
├── SKILL.md              # Skill 核心文档
├── install.md            # CLI 安装指南
├── scripts/install.sh    # curl 安装脚本
├── examples/             # 示例 prompt
├── locales/              # 多语言示例
└── CHANGELOG.md
```

## 支持语言

- 中文(默认)
- English

## 许可证

MIT © HiredChina
