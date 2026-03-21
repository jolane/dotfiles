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
| `lazygit` | Lazygit config with Catppuccin Frappe blue theme | `~/.config/lazygit/` |
| `lazysql` | Lazysql config plus shell wrapper for loading secrets via 1Password | `~/.config/lazysql/` |
| `nvim` | Neovim config with lazy.nvim, LSP, Telescope, Treesitter | `~/.config/nvim/` |
| `opencode` | OpenCode AI assistant config, skills, and instructions | `~/.config/opencode/` |
| `starship` | Starship prompt (minimal, language versions right-aligned) | `~/.config/starship.toml` |
| `zellij` | Zellij multiplexer config (tmux compat layer, vim navigation) | `~/.config/zellij/` |
| `zshrc` | Modular Zsh config (`~/.zshrc` loader plus `~/.config/zsh/*.zsh`) | `~/.zshrc`, `~/.config/zsh/` |

## Prerequisites

- macOS
- Git

Homebrew and all other dependencies are installed by the bootstrap script.

## Installation

```bash
git clone git@github.com:jolane/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The install script will:

1. Install Xcode Command Line Tools (if missing)
2. Install Homebrew (if missing)
3. Run `brew bundle` to install all packages from the Brewfile
4. Symlink each config package into `$HOME` via `stow --dotfiles`
5. Install OpenCode dependencies via `bun` (falls back to `npm`)

The current stowed packages are: `ghostty`, `gitconfig`, `lazygit`,
`lazysql`, `nvim`, `opencode`, `starship`, `zellij`, and `zshrc`.

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
| [bat](https://github.com/sharkdp/bat) | Modern `cat` replacement with syntax highlighting |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder (integrated with Zsh keybindings) |
| [delta](https://dandavison.github.io/delta/) | Git diff pager with syntax highlighting |
| [lazygit](https://github.com/jesseduffield/lazygit) | Terminal UI for Git |
| [yazi](https://yazi-rs.github.io/docs/) | Terminal file manager |
| [GNU Stow](https://www.gnu.org/software/stow/) | Symlink farm manager |

## Neovim

Plugin management via [lazy.nvim](https://github.com/folke/lazy.nvim). LSP
servers are auto-installed through Mason.

**Leader key:** `Space`

| Binding | Action |
|---------|--------|
| `jj` | Exit insert mode (mapped to `<Esc>`) |
| `<leader>e` | Reveal current file in Neo-tree on the left |
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep (Telescope) |
| `<leader>fb` | Open buffers (Telescope) |
| `<leader>fh` | Help tags (Telescope) |
| `<leader>gu` | Copy Git permalink URL to clipboard |
| `<leader>go` | Open Git permalink URL in browser |

**LSP servers:** gopls, ts_ls, eslint, lua_ls, marksman

**Plugins:**

| Plugin | Purpose |
|--------|---------|
| [blink.cmp](https://github.com/Saghen/blink.cmp) | Autocompletion (LSP, path, snippets, buffer) |
| [catppuccin](https://github.com/catppuccin/nvim) | Catppuccin Frappe colorscheme |
| [fugitive](https://github.com/tpope/vim-fugitive) | Git wrapper (`:G` commands) |
| [git-link](https://github.com/juacker/git-link.nvim) | Copy/open Git permalink URLs |
| [lualine](https://github.com/nvim-lualine/lualine.nvim) | Status line |
| [mason](https://github.com/mason-org/mason.nvim) | LSP server auto-installer |
| [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer sidebar |
| [noice](https://github.com/folke/noice.nvim) | UI for cmdline, messages, notifications |
| [startup](https://github.com/startup-nvim/startup.nvim) | Dashboard on launch |
| [telescope](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder (files, grep, buffers, help) |
| [treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting and indentation |
| [which-key](https://github.com/folke/which-key.nvim) | Keybinding hints popup |

Neo-tree is configured to show dotfiles and gitignored files while still
hiding the `.git` directory.

## Shell Aliases

| Alias | Expansion |
|-------|-----------|
| `ls` | `eza --tree --icons --level=1` |
| `ll` | `eza -lah --icons` |
| `tt` | `eza --tree --level=2 --icons` |
| `cat` | `bat` |
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `....` | `cd ../../..` |
| `reload` | `source ~/.zshrc` |

## Shell Layout

The top-level `~/.zshrc` is a small loader that sources modular config files
from `~/.config/zsh/`:

- `completion.zsh` -- case-insensitive tab completion with menu select
- `keybindings.zsh` -- vi mode (`bindkey -v`), fzf integration, history search
- `environment.zsh` -- PATH, `EDITOR`/`VISUAL` set to `nvim`, NVM, `GOPRIVATE`
- `secrets.zsh` -- loads API keys from macOS Keychain via `security`
- `prompt.zsh` -- initializes Starship
- `aliases.zsh` -- see alias table above
- `functions.zsh` -- shell helper functions

Notable shell helpers:

- `take <dir>` creates a directory and enters it
- `sql` launches `lazysql` through `op run` using `~/.config/lazysql/.env`

## OpenCode

The `opencode` package configures the [OpenCode](https://opencode.ai/) AI
coding assistant. Key components:

- **Config** (`opencode.json`) -- model settings, custom AI providers
- **MCP integrations** -- Snyk (security scanning), Atlassian (Jira/Confluence)
- **Skills** -- `create-gitlab-mr` (automated MR workflow), `snyk-fix-single`
  (find and fix a Snyk vulnerability with CI verification)
- **Instructions** (`git-standards.md`) -- enforces branching and commit
  message conventions

## Theme

Catppuccin Frappe is applied across Ghostty, Neovim, Zellij, Starship, and
Lazygit for a unified appearance. The terminal font is JetBrains Mono Nerd
Font at size 15 with background opacity at 0.9 and blur.
