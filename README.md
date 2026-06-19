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

## Multi-machine usage

On a new machine:

```bash
git clone git@github.com:itschriszhao/personal-productivity-skills.git ~/personal-productivity-skills
cd ~/personal-productivity-skills && ./install.sh
```

That's it — every skill is now active under `~/.comate/skills/`.

## License

MIT — see [LICENSE](LICENSE).
