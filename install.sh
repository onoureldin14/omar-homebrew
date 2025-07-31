#!/bin/bash

set -e

REPO_URL="https://raw.githubusercontent.com/onoureldin14/omar-homebrew/main"
CACHE_DIR="$HOME/.dotfiles"
CONFIG_FILE="$HOME/.zshrc"  # Change to ~/.bashrc if needed

echo "📁 Creating local dotfiles directory at $CACHE_DIR"
mkdir -p "$CACHE_DIR"

echo "⬇️  Downloading alias and helper scripts..."
curl -fsSL "$REPO_URL/aliases/terraform_aliases.sh" -o "$CACHE_DIR/terraform_aliases.sh"
curl -fsSL "$REPO_URL/aliases/terragrunt_aliases.sh" -o "$CACHE_DIR/terragrunt_aliases.sh"
curl -fsSL "$REPO_URL/aliases/kubectl_aliases.sh" -o "$CACHE_DIR/kubectl_aliases.sh"
curl -fsSL "$REPO_URL/aliases/azdo_done.sh" -o "$CACHE_DIR/azdo_done.sh"

chmod +x "$CACHE_DIR/azdo_done.sh"

# Add sources to config file if missing
add_source_if_missing() {
  local file="$1"
  local line="source ~/.dotfiles/$file"
  if ! grep -qF "$line" "$CONFIG_FILE"; then
    echo "$line" >> "$CONFIG_FILE"
    echo "✅ Added $line to $CONFIG_FILE"
  else
    echo "ℹ️  $file already sourced in $CONFIG_FILE"
  fi
}

echo "🔧 Updating your $CONFIG_FILE"
echo -e "\n# Added by omar-homebrew install" >> "$CONFIG_FILE"
add_source_if_missing "terraform_aliases.sh"
add_source_if_missing "terragrunt_aliases.sh"
add_source_if_missing "kubectl_aliases.sh"
add_source_if_missing "azdo_done.sh"

# Check for jq and pre-commit
for dep in jq pre-commit; do
  if ! command -v "$dep" >/dev/null 2>&1; then
    echo "⚠️  $dep not found. Attempting install via Homebrew..."
    if command -v brew >/dev/null 2>&1; then
      brew install "$dep"
    else
      echo "❌ Homebrew is not installed. Please install $dep manually."
    fi
  fi
done

echo -e "\n✅ Installation complete."
echo "Run this to load the changes now:"
echo "  source $CONFIG_FILE"