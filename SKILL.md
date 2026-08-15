---
name: hunter-mate
description: HiredChina 猎头 Agent 数据助手:通过 CLI 访问人才库、客户数据、职位数据,并支持浏览器录制解析简历。
---

# HunterMate Skill

## 通用规则:自愈优先,不要把修复推给用户

**任何 agent 使用 hunter-mate 时,发现 server 未运行 / 扩展未连接 / CLI 报错,必须先自动执行 `hunter-mate doctor`**,它会:原生模块 ABI 自检 → 自动启动 server → 自动安装扩展文件 → **检测到扩展未连接时自动打开扩展所在目录 + chrome://extensions 并打印加载引导**。agent 只需把引导转述给用户,不要让用户自己摸索。

## 触发词

- `hunter-mate`
- `猎伴`
- `猎头助手`
- `人才搜索`
- `简历查重`
- `客户案例`

## 适用场景

1. **职位分析 + 人才搜索**:用户把职位 JD/公司资料放在文件夹,要求 Agent 搜索人才库。
2. **浏览器简历查重**:用户在 LinkedIn/Boss 等页面查看简历时,Agent 提示是否已存在于 CRM。
3. **沟通记录归档**:用户上传录音或聊天记录,Agent 生成沟通/推荐记录草稿。
4. **BD 销售方案**:输入客户公司,Agent 检索历史相似客户与可匹配人才,生成销售方案报告。

## 安装与初始化流程

当用户触发本 Skill 后,按以下顺序执行:

### 1. 检查 CLI 是否已安装

```bash
hunter-mate --version
```

- 若返回版本号,跳到步骤 3。
- 若失败,执行步骤 2。

### 2. 安装 CLI

前置:Node.js >= 20(含 npm)。

```bash
curl -fsSL https://raw.githubusercontent.com/hiredchina-com/hunter-mate-skill/main/scripts/install.sh | bash
```

或直接手动安装:

```bash
npm install -g hunter-mate@latest
```

安装脚本会:
- 检查 Node 版本(>= 20)
- 通过 npm 安装 `hunter-mate@latest`
- 检测旧二进制安装(`~/.hunter-mate/bin`,已停止分发)并提示迁移
- 验证 `hunter-mate` 可执行

### 3. 检查登录状态

```bash
hunter-mate status
```

若未登录:

```bash
hunter-mate login
```

这会打开浏览器完成 OAuth 设备码登录。登录后 Token 会存入系统 keychain。

### 4. 检查扩展状态

```bash
hunter-mate doctor
```

doctor 是全链路自检 + 自愈:原生模块 ABI 检查 → server 自动启动 → 扩展文件自动安装 → 扩展 WebSocket 连通检查。

**若扩展未连接,doctor 会自动打开扩展所在目录和 `chrome://extensions`,并打印中文加载引导(不要等用户叫才打开!)**。agent 把引导转述给用户:

> Chrome 地址栏输入 `chrome://extensions/` → 开启右上角「开发者模式」→「加载已解压的扩展程序」→ 选择刚打开的扩展目录。

用户确认加载后,再次 `hunter-mate extension check` 或 `hunter-mate doctor` 确认连接。

## 核心命令速查

### 职位/案件

```bash
# 解析文件夹中的职位资料,生成本地 JobCase
hunter-mate job create <folder-path>

# 列出本地 JobCase
hunter-mate job list

# 打开某个 JobCase
hunter-mate job open <case-id>
```

### 人才搜索

Agent 应将用户的自然语言需求转换为 `--filter` 结构化条件。

```bash
hunter-mate search \
  --filter 'city=Shanghai&industry=Internet&minYears=5&maxSalary=50000' \
  --source 'linkedin,boss,u_person' \
  --top 10
```

也支持 JSON 格式:

```bash
hunter-mate search --json '{
  "city": "Shanghai",
  "industry": "Internet",
  "skills": ["Python", "React"],
  "minYears": 5,
  "maxSalary": 50000
}'
```

常用可搜索字段:
- `city`, `country`
- `industry`, `function`
- `skills` (数组)
- `minYears`, `maxYears`
- `currentCompany`, `targetCompanies`
- `nationality`, `language`
- `source` (数据源: `u_person`, `linkedin`, `boss`, `liepin`)

### 推荐候选

```bash
hunter-mate recommend <case-id> --top 10 --explain
```

### 浏览器简历解析

当用户在浏览器查看简历页面时:

```bash
# 手动提交 URL,触发扩展录制并解析
hunter-mate extension profile <url>
```

或者让用户点击扩展图标开始录制,扩展会自动把数据发送到本地 Server,Server 应用最新 ExtractionRule 解析后返回结构化人才信息。

### 沟通记录

```bash
# 上传录音(本地 STT)
hunter-mate record call <audio.mp3> --local-stt

# 上传聊天记录文本
hunter-mate record transcript <file.txt>

# 生成推荐/沟通记录草稿
hunter-mate record feedback
```

### 报告

```bash
hunter-mate report daily
hunter-mate report weekly
hunter-mate report sales <customer-id>
```

### 版本与更新

CLI **每次被使用时自动检测更新**,无需手动维护:

- **CLI 自更新**:每次命令节流 1h 对比 npm registry,落后自动 `npm install -g hunter-mate@latest`,下一条命令起新版本生效(`HUNTER_MATE_NO_AUTOUPDATE=1` 可禁用)
- **运行时一致性**:server 在跑时对比磁盘版本 vs 运行版本,插件不一致 → 自动 reload,server 不一致 → 自动重启,扩展不一致 → 自动 reload 广播(60s 节流)
- **开发软链模式例外**:当 CLI 是 wrapper 指向 hc-hw `local/*/worktrees/hunter-mate/packages/cli/dist` 时,自动跳过 CLI 自更新(避免 npm 覆盖开发链),一致性 reload/restart 照常生效

手动检查/应用更新:

```bash
hunter-mate update          # 仅检测 CLI/Server/Extension/ExtractionRule 新版本
hunter-mate update --apply  # 检测 + 应用: CLI 自更新(npm) + 一致性修复(reload/重启)
```

## 输出格式约定

- CLI 默认输出 Markdown 表格,便于 Agent 直接展示。
- 使用 `--json` 获取结构化数据,便于 Agent 二次处理。
- 使用 `--lang zh-CN` / `--lang en-US` 切换输出语言。

## 排障路由(TROUBLESHOOTING)

**agent 遇到任何 hunter-mate 报错,先在本表按症状定位,再执行对应修复;不要盲目重试。** 通用第一步:跑 `hunter-mate doctor`(含原生模块 ABI 自检、server/扩展自动修复与加载引导)。详细手册见 hunter-mate 仓库 `TROUBLESHOOTING.md`。

| # | 症状 | 根因 | 修复 |
|---|---|---|---|
| 1 | doctor 报 `native_better-sqlite3: FAIL — ABI 不匹配` / server 启动即崩 | node 版本与原生模块(better-sqlite3)编译 ABI 不匹配(node 22=127/23=131/24=137/25=138/26=147) | ① 切回编译时版本的 node;② 或用当前 node 重编:`pnpm rebuild -r better-sqlite3`(**注意:pnpm 会用登录 shell PATH 里的 node 编译,未必是当前运行 CLI 的 node**)。重编后必须真验证:`node -e "new (require('better-sqlite3'))(':memory:').close()"`——仅 require 不触发 dlopen,是假验证 |
| 2 | doctor 报 `server_auto_start: FAIL 自动启动超时` | server 崩溃(ABI/依赖/端口),后台 spawn 吞掉了报错 | `hunter-mate start -f` 前台看真实报错,按报错对号入座(ABI 错 → 条目 1) |
| 3 | `extension_ws: FAIL` 扩展未连接 | 扩展未加载 / 未开启 | 跑 `hunter-mate doctor`(自动打开扩展目录 + chrome://extensions + 中文引导);按引导「加载已解压的扩展程序」,加载过只是断连则点「重新加载」 |
| 4 | node 报 `EPERM` 写 `~/.hunter-mate/...`(macOS,间歇性) | 系统层拦截 node 写家目录(TCC/安全软件;换 node 来源无效,`/tmp` 不受影响) | 数据目录挪出 `~`:`export HUNTER_MATE_HOME=/tmp` 后重跑 doctor(CLI/扩展/日志全链路识别该变量) |
| 5 | 端口被占 | 孤儿 server 进程 | `lsof -nP -iTCP:<port> -sTCP:LISTEN` 找 pid,kill 后 `hunter-mate start` |
| 6 | CLI 命令超时/无响应 | server 未运行或扩展断连 | 自动 `hunter-mate doctor` 自愈,不要推给用户 |

## 边界与注意事项

1. **服务端无 LLM**:所有意图理解、搜索条件组装、报告生成由你(Agent)使用本地 LLM 完成;CLI/Server 只返回数据。
2. **写操作需确认**:写入 CRM、合并人才、发送报告等操作默认生成草稿,需要用户确认后提交。
3. **PII 脱敏**:CLI 输出中的电话、邮箱等敏感字段会自动部分掩码,不要向外部 LLM 发送完整联系方式。
4. **扩展录制隐私**:扩展只在你指定的白名单域(如 `*.linkedin.com`)启用,录制的整页数据只发送到本地 Server。

## 国际化

- 中文示例:见 `locales/zh-CN.md`
- English examples: see `locales/en-US.md`

## 相关链接

- 私有 monorepo: https://github.com/hiredchina-com/hunter-mate
- 安装脚本: `scripts/install.sh`
- 变更日志: `CHANGELOG.md`
