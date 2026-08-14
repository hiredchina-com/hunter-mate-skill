# 示例:职位分析 + 人才搜索

## 场景

用户把一份职位 JD 和公司介绍放在 `~/Documents/职位A` 文件夹,希望搜索人才库。

## Agent 执行流程

1. 创建 JobCase:

```bash
hunter-mate job create ~/Documents/职位A
```

2. 查看生成的 JobCase 和要求:

```bash
hunter-mate job list
hunter-mate job open <case-id>
```

3. 根据职位要求组装搜索条件:

```bash
hunter-mate search \
  --filter 'city=Shanghai&industry=Internet&minYears=5&skills[]=Python&skills[]=React' \
  --source 'u_person,linkedin' \
  --top 10 \
  --explain
```

4. 向用户展示 Top 10 候选人,并说明匹配理由。

## 用户可能说的话

- "帮我看看这个职位有没有合适的人才"
- "搜索 5 年以上经验的 Python+React,base 上海"
- "这个职位的人才库里有谁?"
