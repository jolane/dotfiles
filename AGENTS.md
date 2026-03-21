# AGENTS.md

This is a macOS dotfiles repository managed with [GNU Stow](https://www.gnu.org/software/stow/).
It provides a reproducible, Vim-oriented development environment built around Neovim, Ghostty,
Zellij, and Starship with a consistent Catppuccin Frappe theme.

## Repository Structure

Each top-level directory is a **Stow package**. Stow's `--dotfiles` flag translates `dot-` prefixes
to `.` at the symlink target (e.g., `dot-config/` becomes `~/.config/`, `dot-zshrc` becomes `~/.zshrc`).

```
brew/          # Homebrew Brewfile
ghostty/       # Ghostty terminal config
gitconfig/     # Global git config
lazygit/       # Lazygit TUI config
lazysql/       # Lazysql config
nvim/          # Neovim config (lazy.nvim, LSP, plugins)
opencode/      # OpenCode AI assistant config, skills, instructions
starship/      # Starship prompt config (TOML)
zellij/        # Zellij multiplexer config (KDL)
zshrc/         # Modular Zsh configuration
```

## Build / Install / Test Commands

There is no build system, test suite, or CI/CD pipeline. This is a dotfiles repo.

```bash
# Full bootstrap on a fresh Mac (installs Xcode CLT, Homebrew, all packages, stows everything)
./install.sh

# Stow a single package into $HOME
stow --dotfiles <package>        # e.g. stow --dotfiles nvim

# Unstow (remove symlinks)
stow -D --dotfiles <package>

# Restow (useful after changing directory structure)
stow -R --dotfiles <package>

# Install OpenCode dependencies (run from opencode/dot-config/opencode/)
bun install        # preferred
npm install        # fallback
```

There are no linting commands, test runners, or build steps for this repository itself.
Linting for projects edited with this Neovim config is handled at the editor/LSP level
(ESLint auto-fix on save, gopls, etc.).

## Code Style Guidelines

### General Formatting

- **Indentation:** 2 spaces everywhere (Lua, Bash, Zsh, TOML, YAML, JSON, KDL, Markdown).
  Never use tabs.
- **Line length:** No strict limit, but keep lines reasonable (~80-100 chars where practical).
- **Trailing whitespace:** Avoid it.
- **Final newline:** Always end files with a newline.

### Lua (Neovim Configuration)

- One plugin per file in `nvim/dot-config/nvim/lua/plugins/`.
- Each plugin file returns a lazy.nvim spec table (e.g., `return { "author/plugin.nvim", ... }`).
- LSP server configs go in `nvim/dot-config/nvim/lsp/` as individual files.
- General config modules go in `nvim/dot-config/nvim/lua/config/`.
- Use `vim.opt` for editor options, `vim.keymap.set` for keybindings.
- Strings: use double quotes for consistency with the existing codebase.
- No type annotations (plain Lua, not Teal or LuaLS annotations).

### Bash / Zsh (Shell Scripts and Config)

- Shebang: `#!/usr/bin/env bash` for scripts.
- Shell config is modular: one `.zsh` file per concern in `zshrc/dot-config/zsh/`.
  The main `dot-zshrc` sources each module.
- Modules: `aliases.zsh`, `completion.zsh`, `environment.zsh`, `functions.zsh`,
  `keybindings.zsh`, `prompt.zsh`, `secrets.zsh`.
- Use `local` for function-scoped variables.
- Use `[[ ]]` for conditionals (not `[ ]`).
- Use colored output helpers (red/green/yellow/bold) in install scripts for user feedback.

### TOML / YAML / KDL / JSON

- Follow the formatting conventions already present in each file.
- TOML: used for Starship and Lazysql configs.
- YAML: used for Lazygit config.
- KDL: used for Zellij config.
- JSON: used for OpenCode config; include `$schema` references where available.

### Naming Conventions

- **Stow packages:** lowercase, single-word directory names at repo root.
- **Stow file prefixes:** `dot-` prefix for files/directories that should become dotfiles
  (e.g., `dot-config` -> `.config`, `dot-zshrc` -> `.zshrc`).
- **Lua files:** lowercase, hyphen-separated (e.g., `neo-tree.lua`, `git-link.lua`).
- **Zsh modules:** lowercase, descriptive (e.g., `keybindings.zsh`, `environment.zsh`).
- **Git branches:** kebab-case, descriptive (e.g., `add-which-key-to-nvim`, `misc-config-updates`).

### Secrets and Sensitive Data

- **Never commit secrets.** API keys and tokens are loaded at runtime from macOS Keychain
  via `security find-generic-password` in `zshrc/dot-config/zsh/secrets.zsh`.
- Database credentials use 1Password CLI (`op run`).
- The `lazysql/dot-config/lazysql/.gitignore` ignores `.env` and `history`.

### Error Handling

- In `install.sh`, track success/failure of each phase; print a summary at the end.
- Use `command -v` to check for tool availability before calling it.
- Warn on Stow conflicts rather than force-overwriting.

## Git Workflow

Follows [GitHub Flow](https://docs.github.com/en/get-started/using-github/github-flow):

- **Never commit directly to `main`.** All changes go on a feature branch.
- Feature branches should represent one logical change.
- Merge to `main` via pull requests.

### Commit Messages

Follow [tbaggery](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) style:

- Subject line <= 50 characters.
- Imperative mood ("Add", "Update", "Fix", "Refactor" -- not "Added", "Updates").
- Capitalize the first letter.
- No trailing period on the subject line.
- Blank line between subject and body (if body is needed).
- Wrap body at ~72 characters.

Examples from this repo:
```
Add nvim plugins
Update bg opacity on Ghostty
Refactor .zshrc setup
Add lazygit
```

### Merge / Pull Requests

PRs should:
- Explain **why** the change is being made.
- Summarize high-level code changes.
- Link relevant Jira tickets or Confluence docs if applicable.
- Include testing notes.

## Theme and Visual Consistency

**Catppuccin Frappe** is applied across all tools. When adding or modifying configs for
visual tools, use the Frappe palette to maintain consistency:

- Ghostty: `theme = "Catppuccin Frappe"`
- Neovim: `catppuccin-frappe` colorscheme
- Zellij: `theme "catppuccin-frappe"`
- Starship: Frappe palette defined inline
- Lazygit: Catppuccin Frappe accent colors
- Font: JetBrains Mono Nerd Font (size 15)

## Adding a New Stow Package

1. Create a new top-level directory named after the tool (lowercase, single word).
2. Mirror the target directory structure inside it using `dot-` prefixes.
   Example: to create `~/.config/foo/config.toml`, make `foo/dot-config/foo/config.toml`.
3. Add a `.gitignore` inside the package if it generates local state files.
4. Run `stow --dotfiles <package>` to symlink it.
5. Document the new package in `README.md`.

## Key Files Reference

| File | Purpose |
|------|---------|
| `install.sh` | Bootstrap script for fresh macOS setup |
| `brew/Brewfile` | All Homebrew formulae, casks, and taps |
| `nvim/dot-config/nvim/init.lua` | Neovim entry point (editor options, keymaps) |
| `nvim/dot-config/nvim/lua/config/lazy.lua` | lazy.nvim plugin manager bootstrap |
| `nvim/dot-config/nvim/lua/config/lsp.lua` | LSP keybindings and on-attach config |
| `zshrc/dot-zshrc` | Main Zsh entry point (sources modular configs) |
| `opencode/dot-config/opencode/opencode.json` | OpenCode AI assistant configuration |
