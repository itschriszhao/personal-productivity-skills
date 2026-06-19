<div align="center">

# 🛠️ My Productivity Stash

> 自用工具箱 · 不定期补货

![](https://img.shields.io/badge/for-myself-ff69b4) ![](https://img.shields.io/badge/cost-%240-brightgreen) ![](https://img.shields.io/badge/vibe-WIP-yellow)

</div>

---

## 🚀 一行命令上手

```bash
git clone git@github.com:itschriszhao/personal-productivity-skills.git ~/personal-productivity-skills && cd ~/personal-productivity-skills && ./install.sh
```

`install.sh` 把 `skills/*` 软链到 AI agent 的 skills 目录。幂等，可 `--dry-run`。卸载用 `./uninstall.sh`。

---

## 🧩 Skills

> 直接被 AI 自动调用的指令集，丢在 `skills/<name>/SKILL.md` 即可。

_（暂时空着，加一个填一行）_

---

## 📦 子项目

| 项目 | 一句话 |
|------|--------|
| 🪴 [obsidian-free-sync](https://github.com/itschriszhao/obsidian-free-sync) | 用 GitHub 私仓免费同步 Obsidian，跨 Mac / 跨 Apple ID 都能用 |
| 🎨 [10-dribbble-vibes](https://github.com/itschriszhao/10-dribbble-vibes) | 10 套高审美单文件 HTML 模板，丢给 AI Agent 一键采用配色与布局 |

---

## 📁 结构

```
.
├── install.sh / uninstall.sh   # 软链到 ~/.<agent>/skills/
├── skills/                     # 每个子目录 = 一个 Skill
└── README.md                   # ← 你在这
```

---

## ➕ 加新 Skill

```bash
mkdir -p skills/<name>
# 写 skills/<name>/SKILL.md（带 frontmatter: name / description）
./install.sh
git add skills/<name> && git commit -m "feat: <name>" && git push
```

---

<div align="center">

☕ by [@itschriszhao](https://github.com/itschriszhao)

</div>
