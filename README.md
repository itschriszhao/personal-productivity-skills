# personal-productivity-skills

A personal productivity OS built with Obsidian, GitHub, Feishu, and AI agents — free, open, and battle-tested.

This repo collects [Comate](https://comate.baidu.com/) / Claude-style **Skills** (and supporting scripts) accumulated during daily work. They are designed to be:

- Used directly on this machine via a single `install.sh`
- Open-sourced for reuse on other machines / by others

## Quick start

```bash
git clone git@github.com:itschriszhao/personal-productivity-skills.git ~/personal-productivity-skills
cd ~/personal-productivity-skills
./install.sh
```

`install.sh` symlinks each `skills/<name>/` directory into `~/.comate/skills/<name>`, so Comate (and compatible agents) auto-discover them. The script is idempotent and supports `--dry-run`.

To remove the links:

```bash
./uninstall.sh
```

## Layout

```
personal-productivity-skills/
├── install.sh        # symlink skills/* -> ~/.comate/skills/
├── uninstall.sh
├── skills/           # one subdirectory per skill (each with SKILL.md)
├── LICENSE
└── README.md
```

## Adding a new skill

1. Create `skills/<your-skill>/SKILL.md` with proper frontmatter (`name`, `description`, etc.).
2. Add any supporting files alongside it (scripts, references, prompts).
3. Run `./install.sh` once to link it.
4. Commit and push:

   ```bash
   git add skills/<your-skill>
   git commit -m "feat(skill): add <your-skill>"
   git push
   ```

## Related projects（子仓索引）

独立成仓、各自有完整 README 的工具型项目：

| 项目 | 简介 | 链接 |
|------|------|------|
| obsidian-free-sync | 用 Git + GitHub 私有仓库免费同步 Obsidian Vault，跨 Mac / 跨 Apple ID 都能用，自带 Comate Skill 一键配置 | [itschriszhao/obsidian-free-sync](https://github.com/itschriszhao/obsidian-free-sync) |

新增子仓时在表格里追加一行即可。

## Multi-machine usage

On a new machine:

```bash
git clone git@github.com:itschriszhao/personal-productivity-skills.git ~/personal-productivity-skills
cd ~/personal-productivity-skills && ./install.sh
```

That's it — every skill is now active under `~/.comate/skills/`.

## License

MIT — see [LICENSE](LICENSE).
