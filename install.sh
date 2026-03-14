#!/usr/bin/env bash
#
# install.sh -- Bootstrap a fresh macOS machine from this dotfiles repo.
#
# Usage:
#   git clone <repo> ~/dotfiles
#   cd ~/dotfiles
#   ./install.sh
#
# Safe to re-run. Stow conflicts are warned, not forced.

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Stow packages to symlink (order doesn't matter)
PACKAGES=(
  ghostty
  gitconfig
  lazygit
  lazysql
  nvim
  opencode
  starship
  zellij
  zshrc
)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

red()    { printf '\033[0;31m%s\033[0m\n' "$*"; }
green()  { printf '\033[0;32m%s\033[0m\n' "$*"; }
yellow() { printf '\033[0;33m%s\033[0m\n' "$*"; }
bold()   { printf '\033[1m%s\033[0m\n' "$*"; }

info()    { bold "==> $*"; }
success() { green "  [ok] $*"; }
warn()    { yellow "  [warn] $*"; }
fail()    { red "  [fail] $*"; }

# ---------------------------------------------------------------------------
# 1. Xcode Command Line Tools
# ---------------------------------------------------------------------------

info "Checking for Xcode Command Line Tools..."

if xcode-select -p &>/dev/null; then
  success "Xcode CLT already installed"
else
  info "Installing Xcode Command Line Tools (follow the prompt)..."
  xcode-select --install
  echo "Press any key once the installation is complete..."
  read -r -n 1
fi

# ---------------------------------------------------------------------------
# 2. Homebrew
# ---------------------------------------------------------------------------

info "Checking for Homebrew..."

if command -v brew &>/dev/null; then
  success "Homebrew already installed"
else
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to PATH for the rest of this script
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

if ! command -v brew &>/dev/null; then
  fail "Homebrew installation failed or not in PATH. Aborting."
  exit 1
fi

# ---------------------------------------------------------------------------
# 3. Brew Bundle
# ---------------------------------------------------------------------------

info "Installing packages from Brewfile..."

if brew bundle --file="$DOTFILES_DIR/brew/Brewfile"; then
  success "Brew bundle complete"
else
  warn "Some brew bundle items may have failed (see output above)"
fi

# ---------------------------------------------------------------------------
# 4. Stow Packages
# ---------------------------------------------------------------------------

info "Linking dotfiles with GNU Stow..."

if ! command -v stow &>/dev/null; then
  fail "stow not found. Install it with: brew install stow"
  exit 1
fi

succeeded=()
failed=()

for pkg in "${PACKAGES[@]}"; do
  if stow --dir="$DOTFILES_DIR" --target="$HOME" --dotfiles "$pkg" 2>&1; then
    success "$pkg"
    succeeded+=("$pkg")
  else
    fail "$pkg -- conflict detected. Remove or move the existing file(s), then re-run."
    failed+=("$pkg")
  fi
done

# ---------------------------------------------------------------------------
# 5. OpenCode Dependencies
# ---------------------------------------------------------------------------

info "Installing OpenCode dependencies..."

OPENCODE_DIR="$HOME/.config/opencode"

if [[ -f "$OPENCODE_DIR/package.json" ]]; then
  if command -v bun &>/dev/null; then
    (cd "$OPENCODE_DIR" && bun install)
    success "OpenCode dependencies installed (bun)"
  elif command -v npm &>/dev/null; then
    (cd "$OPENCODE_DIR" && npm install)
    success "OpenCode dependencies installed (npm)"
  else
    warn "Neither bun nor npm found. Skipping OpenCode dependency install."
  fi
else
  if [[ " ${failed[*]} " == *" opencode "* ]]; then
    warn "OpenCode was not stowed -- skipping dependency install"
  else
    warn "No package.json found at $OPENCODE_DIR -- skipping"
  fi
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

echo ""
info "Done!"

if [[ ${#succeeded[@]} -gt 0 ]]; then
  green "  Linked: ${succeeded[*]}"
fi

if [[ ${#failed[@]} -gt 0 ]]; then
  red "  Failed: ${failed[*]}"
  echo ""
  yellow "  To resolve conflicts, remove the existing files and re-run:"
  yellow "    ./install.sh"
  yellow ""
  yellow "  Or stow individual packages:"
  yellow "    stow --dotfiles <package>"
fi

echo ""
bold "Restart your shell or run: source ~/.zshrc"
