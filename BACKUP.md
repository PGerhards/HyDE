# Config backup & upstream-sync strategy (this fork)

This fork of HyDE doubles as a backup of the desktop/theming layer for the
`pascal-eos` (Arch/EndeavourOS) machine. To keep upstream merges painless, it
follows a strict **two-owner, override-only** model.

## Who owns what

| Layer | Owner | Notes |
|-------|-------|-------|
| Desktop / theming (hypr, waybar, hyde `config.toml`, rofi, dunst, …) | **This HyDE fork** | Natural owner; backed up here. |
| Portable user dotfiles (nvim, wezterm, pipewire, eza, ohmyposh) | **chezmoi** (`PGerhards/dotfiles`) | No overlap with HyDE. |
| zsh **framework** (`~/.zshenv` → `ZDOTDIR`, `conf.d/`, `user.zsh` flags) | **This HyDE fork** | Provides the structure only. |
| zsh **content** (zinit plugins, oh-my-posh prompt, aliases, tools) | **chezmoi** | Single source of truth, see below. |

## zsh: HyDE framework + chezmoi content

- HyDE provides the framework. `conf.d/hyde/terminal.zsh` sources
  `$ZDOTDIR/.zshrc` **last**, so it behaves exactly like a normal `~/.zshrc`.
- `user.zsh` only sets `HYDE_ZSH_NO_PLUGINS=1` and `unset HYDE_ZSH_PROMPT` so
  HyDE's own oh-my-zsh plugins and starship/p10k prompt stay off.
- chezmoi owns the actual zsh content as a **single shared template**
  (`.chezmoitemplates/zshrc`) and routes it per machine via `.chezmoiignore`:
  - `pascal-eos` → `~/.config/zsh/.zshrc` (into the HyDE framework)
  - other hosts → `~/.zshrc`
- Therefore `restore_cfg.psv` keeps `.zshrc` at **`P`** (HyDE never overwrites the
  chezmoi-managed file).

## Customize via override files only — never framework files

Edit only: `config.toml`, `hypr/userprefs.conf`, `hypr/keybindings.conf`,
`hypr/monitors.conf`, your own waybar layout (`waybar/layouts/pascal.jsonc`), and
`zsh/user.zsh`. Leave framework and themepatcher-generated files
(`themes/theme.conf`, `colors.conf`, `wallbash.conf`) untouched. This keeps
`git merge upstream/dev` essentially conflict-free.

## restore_cfg.psv flags

`P` = install repo default only if the target is missing (preserve live config).
`S` = overwrite the live target with the repo version (repo is source of truth).
Use `S` for files you back up here (your override files + HyDE-owned desktop
configs); use `P` for chezmoi-owned and runtime-generated files.
**Discipline:** commit changes before re-running restore, or `S` will overwrite
uncommitted live tweaks.

## Sync with upstream

```sh
git remote add upstream https://github.com/HyDE-Project/HyDE.git   # once
git fetch upstream
git checkout dev
git merge upstream/dev      # clean, because only override files are touched
```
Only `dev` is used on this fork; `master` is ignored.
