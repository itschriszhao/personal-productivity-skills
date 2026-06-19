---
name: update-subproject-link
description: 把一个 GitHub 子项目仓库链接登记到 personal-productivity-skills 的 README——同时维护「📦 子项目」和「🧩 Skills」两张表（若子项目自带 skill/SKILL.md 则自动加进 Skills 表）。当用户说"加到我的子项目"、"更新 personal 仓库的子项目列表"、"把这个仓库链接加到总仓 README"、"把 xxx 加到我的工具箱"、"register sub-repo"、"add to my productivity stash"，或提供 GitHub 仓库 URL 并表示要登记到总仓时触发。
---

# 更新 personal-productivity-skills 索引

把指定的 GitHub 仓库登记到 `~/personal-productivity-skills/README.md`：

1. **📦 子项目** 表 — 必加一行
2. **🧩 Skills** 表 — 若子项目根目录或 `skill/` 下存在 `SKILL.md`，自动加一行

完成后 commit & push。

## 输入

- **repo URL**：完整 GitHub 地址（HTTPS 或 SSH 任意）
- **emoji**（可选，子项目表用）：默认 `📌`
- **一句话简介**（可选）：未提供则自动 GitHub API 抓 `description` 让用户确认

## 执行流程

### Step 1：定位总仓

```bash
REPO="${HOME}/personal-productivity-skills"
README="${REPO}/README.md"
test -f "$README" || { echo "总仓 README 不存在: $README"; exit 1; }
```

未 clone：提示用户 `git clone git@github.com:itschriszhao/personal-productivity-skills.git ~/personal-productivity-skills`。

### Step 2：解析 URL

提取 `<owner>/<name>`，规范化 HTTPS：`https://github.com/<owner>/<name>`。

### Step 3：去重检查

```bash
grep -F "github.com/<owner>/<name>" "$README" && echo "已登记，是否更新？"
```

已存在则询问用户是否覆盖；否则跳过。

### Step 4：补全简介

未提供则：

```bash
curl -s "https://api.github.com/repos/<owner>/<name>" \
  | python3 -c "import sys,json; print(json.load(sys.stdin).get('description') or '')"
```

将抓到的内容给用户确认/编辑。私有仓库或限流则让用户手输。

### Step 5：探测子项目里的 SKILL.md

调用 GitHub API 检查（不必 clone）：

```bash
# 先看 skill/SKILL.md（推荐位置），再看根目录 SKILL.md
SKILL_PATH=""
for p in "skill/SKILL.md" "SKILL.md"; do
  if curl -sf "https://api.github.com/repos/<owner>/<name>/contents/$p" -o /dev/null; then
    SKILL_PATH="$p"; break
  fi
done
```

若找到，再抓出 `name` 和 `description`（frontmatter）：

```bash
curl -sL "https://raw.githubusercontent.com/<owner>/<name>/main/$SKILL_PATH" | python3 <<'PY'
import sys, re
text = sys.stdin.read()
m = re.search(r'^---\s*\n(.*?)\n---', text, re.S | re.M)
if not m: sys.exit(0)
fm = m.group(1)
name = re.search(r'^name:\s*(.+)$', fm, re.M)
desc = re.search(r'^description:\s*(.+)$', fm, re.M)
print((name.group(1).strip() if name else '') + '\t' + (desc.group(1).strip() if desc else ''))
PY
```

把 skill name 和一句话用途展示给用户确认。description 太长可裁到首句。

### Step 6：写入 README（两张表）

用 Python 在两张表末尾各追加一行：

```bash
EMOJI="🪴" \
PROJ_NAME="repo-name" \
PROJ_URL="https://github.com/<owner>/<name>" \
PROJ_DESC="一句话简介" \
SKILL_NAME="skill-name-from-frontmatter" \
SKILL_URL="https://github.com/<owner>/<name>/blob/main/<SKILL_PATH>" \
SKILL_USAGE="一句话用途" \
README="$README" \
python3 <<'PY'
import os, re, sys
from pathlib import Path

readme = Path(os.environ['README'])
text = readme.read_text(encoding='utf-8')

emoji      = os.environ.get('EMOJI', '📌')
proj_name  = os.environ['PROJ_NAME']
proj_url   = os.environ['PROJ_URL']
proj_desc  = os.environ['PROJ_DESC']

# ---- 1. 追加到「📦 子项目」表 ----
proj_pat = re.compile(r'(## 📦 子项目\n\n\| 项目 \| 一句话 \|\n\|[^\n]*\|\n)((?:\|[^\n]*\|\n)*)', re.M)
m = proj_pat.search(text)
if not m:
    sys.exit("未找到「📦 子项目」表，README 结构可能已变")
proj_row = f"| {emoji} [{proj_name}]({proj_url}) | {proj_desc} |\n"
if proj_row not in text:
    text = text[:m.end()] + proj_row + text[m.end():]
    print("加入子项目表:", proj_row.strip())

# ---- 2. 若有 SKILL.md，追加到「🧩 Skills」表 ----
skill_name  = os.environ.get('SKILL_NAME', '').strip()
skill_url   = os.environ.get('SKILL_URL', '').strip()
skill_usage = os.environ.get('SKILL_USAGE', '').strip()

if skill_name and skill_url:
    skill_pat = re.compile(
        r'(## 🧩 Skills\n\n>[^\n]*\n\n\| Skill \| 来源 \| 用途 \|\n\|[^\n]*\|\n)((?:\|[^\n]*\|\n)*)',
        re.M
    )
    m2 = skill_pat.search(text)
    if not m2:
        sys.exit("未找到「🧩 Skills」表，README 结构可能已变")
    skill_row = f"| [{skill_name}]({skill_url}) | {emoji} {proj_name} | {skill_usage} |\n"
    # 若 Skills 表里目前是占位行（含 "暂时空着"），整段替换
    body = m2.group(2)
    if '暂时空着' in body or body.strip() == '':
        text = text[:m2.start(2)] + skill_row + text[m2.end(2):]
    elif skill_row not in text:
        text = text[:m2.end()] + skill_row + text[m2.end():]
    print("加入 Skills 表:", skill_row.strip())

readme.write_text(text, encoding='utf-8')
PY
```

### Step 7：展示 diff，等用户确认

```bash
cd "$REPO" && git diff README.md
```

### Step 8：commit & push

```bash
cd "$REPO"
git add README.md
git commit -m "docs: register <name> (sub-project + skill)"
# 或仅子项目：docs: register <name> sub-project
git push
```

push 失败：`git pull --rebase && git push`，仍失败则停止报告。

## 异常处理

| 情况 | 处理 |
|------|------|
| 总仓未 clone | 提示 clone 命令后停止 |
| 表格结构被改 | 正则匹配失败，停止报告，让用户人工补 |
| GitHub API 限流（403） | 跳过自动抓简介与 SKILL frontmatter，让用户手输 |
| 私有仓库 description 抓不到 | API 404，让用户手输 |
| 子项目无 SKILL.md | 跳过 Skills 表，仅更新子项目表 |
| Skills 表当前是占位（含"暂时空着"） | 用新行**替换**整段表体，而非追加 |
| push 被拒 | `git pull --rebase` 后重试 |

## 完成回报格式

```
✅ 已更新 personal-productivity-skills

📦 子项目 + 🧩 Skill：🪴 obsidian-free-sync / obsidian-free-sync-setup
commit：1831d31
查看：https://github.com/itschriszhao/personal-productivity-skills#-子项目
```

仅子项目无 Skill 时，省略「🧩 Skill」一行。
