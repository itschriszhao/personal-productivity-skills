<div align="center">

# 🛠️ personal-productivity-skills

**个人效率工具箱 —— Skills 与子项目索引**

![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey)

</div>

---

## ✨ 这是什么？

日常工作里积累的效率工具集合，分两类：

- 🧩 **AI Skills**：可被 Claude Code / 其它支持 Skills 协议的 AI agent 自动调用的指令集
- 📦 **Sub-projects**：独立成仓的工具型项目（见下方 [子项目索引](#-子项目索引)）

设计目标：**自用顺手 + 多机复用 + 开源他人也能用**。

---

## 🚀 Quick start

```bash
git clone git@github.com:itschriszhao/personal-productivity-skills.git ~/personal-productivity-skills
cd ~/personal-productivity-skills
./install.sh
```

`install.sh` 把 `skills/<name>/` 软链到 `~/.<agent>/skills/<name>`，让 AI agent 自动发现。
脚本幂等，支持 `--dry-run` 预览，配套 `./uninstall.sh` 一键卸载。

> 默认目标目录可通过环境变量覆盖：`SKILLS_DST=~/.claude/skills ./install.sh`

---

## 🗂️ 目录结构

```
personal-productivity-skills/
├── install.sh        # 软链 skills/* → ~/.<agent>/skills/
├── uninstall.sh
├── skills/           # 每个子目录 = 一个 Skill（含 SKILL.md）
├── LICENSE
└── README.md
```

---

## ➕ 添加新 Skill

1. 新建 `skills/<your-skill>/SKILL.md`，写好 frontmatter（`name`, `description`）
2. 配套脚本/参考文档一起放进去
3. `./install.sh` 链接生效
4. 提交：

```bash
git add skills/<your-skill>
git commit -m "feat(skill): add <your-skill>"
git push
```

---

## 🌐 子项目索引

独立成仓、各自有完整 README 的工具型项目：

| 项目 | 简介 | 链接 |
|------|------|------|
| 🪴 **obsidian-free-sync** | 用 Git + GitHub 私有仓库免费同步 Obsidian vault，跨 Mac / 跨 Apple ID 都能用 | [itschriszhao/obsidian-free-sync](https://github.com/itschriszhao/obsidian-free-sync) |

> 新增子仓时在表格里追加一行即可。

---

## 💻 多机复用

新机器上：

```bash
git clone git@github.com:itschriszhao/personal-productivity-skills.git ~/personal-productivity-skills
cd ~/personal-productivity-skills && ./install.sh
```

完成。所有 Skill 立即可用。

---

<div align="center">

—— Made with ☕ by [@itschriszhao](https://github.com/itschriszhao) · MIT License

</div>
