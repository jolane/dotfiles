# dotfiles

macOS dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).
Vim-oriented workflow built around Neovim, Ghostty, Zellij, and Starship
with a consistent **Catppuccin Frappe** theme throughout.

## What's Included

| Package | Description | Stow Target |
|---------|-------------|-------------|
| `brew` | Homebrew formulae, casks, and taps (via `brew bundle`) | N/A -- standalone |
| `ghostty` | Ghostty terminal config (Catppuccin Frappe, JetBrains Mono, translucent) | `~/.config/ghostty/` |
| `gitconfig` | Global Git config (delta pager, SSH rewrites, zdiff3 merges) | `~/.gitconfig` |
| `nvim` | Neovim config with lazy.nvim, LSP, Telescope, Treesitter | `~/.config/nvim/` |
| `opencode` | OpenCode AI assistant config, skills, and instructions | `~/.config/opencode/` |
| `starship` | Starship prompt (minimal, language versions right-aligned) | `~/.config/starship.toml` |
| `zellij` | Zellij multiplexer config (tmux compat layer, vim navigation) | `~/.config/zellij/` |
| `zshrc` | Zsh config (vi-mode, completions, aliases, NVM, Starship) | `~/.zshrc` |

## Prerequisites

- macOS
- Git

Homebrew and all other dependencies are installed by the bootstrap script.

## Installation

```bash
git clone git@github.com:<user>/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The install script will:

1. Install Xcode Command Line Tools (if missing)
2. Install Homebrew (if missing)
3. Run `brew bundle` to install all packages from the Brewfile
4. Symlink each config package into `$HOME` via `stow --dotfiles`
5. Install OpenCode dependencies via `bun`

If stow encounters a conflict (existing file at the target path), it will
warn you and skip that package. Remove or move the conflicting file, then
re-run `./install.sh` or stow the package manually.

## Manual Usage

Stow or unstow individual packages from the repo root:

```bash
# Link a single package
stow --dotfiles <package>

# Unlink a single package
stow -D --dotfiles <package>

# Re-link (useful after adding files to a package)
stow -R --dotfiles <package>
```

The `--dotfiles` flag translates the `dot-` prefix convention to `.` at the
target, so `dot-config/` becomes `.config/` and `dot-zshrc` becomes `.zshrc`.

## Key Tools

| Tool | Purpose |
|------|---------|
| [Neovim](https://neovim.io/) | Primary editor and IDE |
| [Ghostty](https://ghostty.org/) | Terminal emulator |
| [Zellij](https://zellij.dev/) | Terminal multiplexer (tmux alternative) |
| [Starship](https://starship.rs/) | Cross-shell prompt |
| [eza](https://eza.rocks/) | Modern `ls` replacement |
| [delta](https://dandavison.github.io/delta/) | Git diff pager with syntax highlighting |
| [lazygit](https://github.com/jesseduffield/lazygit) | Terminal UI for Git |
| [GNU Stow](https://www.gnu.org/software/stow/) | Symlink farm manager |

## Neovim

Plugin management via [lazy.nvim](https://github.com/folke/lazy.nvim). LSP
servers are auto-installed through Mason.

**Leader key:** `Space`

| Binding | Action |
|---------|--------|
| `<leader>e` | Toggle file explorer (Neo-tree) |
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep (Telescope) |
| `<leader>fb` | Open buffers (Telescope) |
| `<leader>fh` | Help tags (Telescope) |

**LSP servers:** gopls, ts_ls, eslint, lua_ls, marksman

## Shell Aliases

| Alias | Expansion |
|-------|-----------|
| `ls` | `eza --tree --icons --level=1` |
| `ll` | `eza -lah --icons` |
| `tt` | `eza --tree --level=2 --icons` |
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `reload` | `source ~/.zshrc` |

## Theme

Catppuccin Frappe is applied consistently across Ghostty, Neovim, and Zellij
for a unified appearance. The terminal font is JetBrains Mono at size 15 with
background opacity at 0.7 and blur.
