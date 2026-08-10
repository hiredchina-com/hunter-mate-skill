# 示例:沟通记录归档

## 场景

用户上传一段与客户的微信语音或录音,Agent 需要生成沟通记录和推荐记录草稿。

## Agent 执行流程

1. 转写录音:

```bash
hunter-mate record call ~/Downloads/call_20260811.mp3 --local-stt
```

2. 查看转写文本:

```bash
hunter-mate record transcript ~/.hunter-mate/transcripts/call_20260811.txt
```

3. 使用本地 LLM 分析转写文本,抽取:
   - 客户公司/联系人
   - 相关 JobCase
   - 候选人姓名
   - 意向与下一步

4. 生成沟通记录草稿:

```bash
hunter-mate record feedback \
  --job-case <case-id> \
  --customer <customer-id> \
  --talent <talent-profile-id> \
  --summary "客户对候选人 A 感兴趣,希望下周安排面试" \
  --next-steps "安排周四下午 2 点面试"
```

5. 向用户展示草稿,确认后写回 CRM。

## 用户可能说的话

- "帮我把这段录音整理成沟通记录"
- "这是今天和客户聊的内容,记一下"
- "生成推荐记录草稿"
