---
name: update-subproject-link
description: 把一个 GitHub 子项目仓库链接追加到 personal-productivity-skills 的 README 「📦 子项目」表格里。当用户说"加到我的子项目"、"更新 personal 仓库的子项目列表"、"把这个仓库链接加到总仓 README"、"把 xxx 加到我的工具箱"、"register sub-repo"、"add to my productivity stash"，或提供 GitHub 仓库 URL 并表示要登记到总仓时触发。
---

# 更新 personal-productivity-skills 子项目列表

把指定的 GitHub 仓库登记到 `~/personal-productivity-skills/README.md` 「📦 子项目」表格中，自动 commit & push。

## 输入

- **repo URL**：完整 GitHub 地址，形如 `https://github.com/<owner>/<name>` 或 SSH `git@github.com:<owner>/<name>.git`
- **emoji**（可选）：表格首列前缀图标，默认 `📌`
- **一句话简介**（可选）：若用户没给，主动用 GitHub API 抓 `description`，再让用户确认

## 执行流程

### Step 1：定位总仓

```bash
REPO="${HOME}/personal-productivity-skills"
README="${REPO}/README.md"
test -f "$README" || { echo "总仓 README 不存在: $README"; exit 1; }
```

### Step 2：解析 URL

从输入提取 `<owner>/<name>`，并构造规范化 HTTPS 链接：`https://github.com/<owner>/<name>`。

### Step 3：去重检查

```bash
grep -F "github.com/<owner>/<name>" "$README" && {
  echo "已存在，跳过追加"; exit 0;
}
```

如已存在，告知用户并询问是否要更新简介；不要重复追加行。

### Step 4：补全简介（可选）

若用户没给简介，调用 GitHub API：

```bash
curl -s "https://api.github.com/repos/<owner>/<name>" | python3 -c "import sys,json; print(json.load(sys.stdin).get('description') or '')"
```

把抓到的 description 给用户看，问是否使用 / 修改。

### Step 5：追加表格行

README 里目标表格形如：

```markdown
## 📦 子项目

| 项目 | 一句话 |
|------|--------|
| 🪴 [obsidian-free-sync](https://github.com/itschriszhao/obsidian-free-sync) | 用 GitHub 私仓免费同步 Obsidian，跨 Mac / 跨 Apple ID 都能用 |
```

用 Python 在表格末尾追加一行（避免 sed 处理 markdown 表格易出错）：

```bash
python3 <<'PY'
from pathlib import Path
import re, sys, os

readme = Path(os.environ['README'])
emoji  = os.environ.get('EMOJI', '📌')
name   = os.environ['NAME']
url    = os.environ['URL']
desc   = os.environ['DESC']

text = readme.read_text(encoding='utf-8')

# 定位 ## 📦 子项目 ... 下一段（## 或 --- 或 EOF）
pattern = re.compile(r'(## 📦 子项目\n\n\| 项目 \| 一句话 \|\n\|[^\n]*\|\n)((?:\|[^\n]*\|\n)*)', re.MULTILINE)
m = pattern.search(text)
if not m:
    sys.exit("未找到「📦 子项目」表格，README 结构可能已变，需手动更新")

new_row = f"| {emoji} [{name}]({url}) | {desc} |\n"
new_text = text[:m.end()] + new_row + text[m.end():]
# 防止重复
if new_row in text:
    print("行已存在，未改动"); sys.exit(0)
readme.write_text(new_text, encoding='utf-8')
print("已追加:", new_row.strip())
PY
```

调用方式：

```bash
EMOJI="🪴" NAME="repo-name" URL="https://github.com/<owner>/<name>" DESC="一句话简介" README="$README" bash -c '...上面 python 块...'
```

### Step 6：展示 diff，等用户确认

```bash
cd "$REPO" && git diff README.md
```

告诉用户改动内容，等用户回 "确认 / ok" 再继续。

### Step 7：commit & push

```bash
cd "$REPO"
git add README.md
git commit -m "docs: add <name> to sub-projects"
git push
```

成功后回报 commit hash 和总仓 README 在线链接：
`https://github.com/itschriszhao/personal-productivity-skills#-子项目`

## 异常处理

- **总仓未 clone**：提示用户先 `git clone git@github.com:itschriszhao/personal-productivity-skills.git ~/personal-productivity-skills`
- **表格结构被改过**：Step 5 的正则匹配失败，停止并请用户人工补一行
- **GitHub API 限流**（403 / rate limit）：跳过自动抓简介，让用户手输
- **push 被拒（远程有更新）**：执行 `git pull --rebase && git push`，仍失败则停止报告
- **私有仓库 description 抓不到**：API 返回 404，让用户手输

## 完成回报格式

```
✅ 已更新 personal-productivity-skills

新增：🪴 obsidian-free-sync
简介：用 GitHub 私仓免费同步 Obsidian
commit：a2ca0f5
查看：https://github.com/itschriszhao/personal-productivity-skills#-子项目
```
