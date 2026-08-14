# 示例:浏览器简历查重

## 场景

用户在 LinkedIn 查看某个候选人简历,Agent 需要提示该人才是否已存在于公司 CRM。

## Agent 执行流程

1. 检查扩展状态:

```bash
hunter-mate extension check
```

2. 让用户在 LinkedIn 页面停留几秒,扩展会自动录制并发送数据到本地 Server。

3. 手动触发解析(如果扩展未自动返回):

```bash
hunter-mate extension profile "https://www.linkedin.com/in/example/"
```

4. CLI 返回解析结果与 CRM 查重结果:

```markdown
| 字段 | 解析值 | CRM 状态 |
|---|---|---|
| 姓名 | 张三 | 已存在(personId: 12345) |
| 公司 | ByteDance | - |
| 职位 | Senior Engineer | - |
| 联系方式 | 已购买 | 由同事李四于 2026-05-01 购买 |
```

## 用户可能说的话

- "帮我查一下这个人我们有没有"
- "这个 LinkedIn 简历有没有联系方式"
- "这个人之前是不是同事推荐过"
