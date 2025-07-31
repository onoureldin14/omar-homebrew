#!/bin/bash

set -e

REPO="https://raw.githubusercontent.com/onoureldin14/omar-homebrew/main"
CACHE_DIR="$HOME/.dotfiles"
CONFIG_FILE="$HOME/.zshrc"  # Change this to ~/.bashrc if using Bash

echo "[INFO] Ensuring cache directory exists at $CACHE_DIR"
mkdir -p "$CACHE_DIR"

echo "[INFO] Downloading alias files..."
curl -fsSL "$REPO/aliases/terraform_aliases.sh" -o "$CACHE_DIR/terraform_aliases.sh"
curl -fsSL "$REPO/aliases/terragrunt_aliases.sh" -o "$CACHE_DIR/terragrunt_aliases.sh"
curl -fsSL "$REPO/aliases/kubectl_aliases.sh" -o "$CACHE_DIR/kubectl_aliases.sh"
curl -fsSL "$REPO/aliases/azdo_done.sh" -o "$CACHE_DIR/azdo_done.sh"

echo "[INFO] Setting executable permissions..."
chmod +x "$CACHE_DIR/azdo_done.sh"

# Helper function to safely add sourcing if not already present
add_source_if_missing() {
  local file="$1"
  local marker="source ~/.dotfiles/$file"
  if ! grep -Fxq "$marker" "$CONFIG_FILE"; then
    echo "$marker" >> "$CONFIG_FILE"
    echo "[INFO] Added $marker to $CONFIG_FILE"
  else
    echo "[SKIP] $marker already present in $CONFIG_FILE"
  fi
}

echo "[INFO] Updating $CONFIG_FILE with source lines..."
echo "" >> "$CONFIG_FILE"
echo "# Added by omar-homebrew installer" >> "$CONFIG_FILE"
add_source_if_missing "terraform_aliases.sh"
add_source_if_missing "terragrunt_aliases.sh"
add_source_if_missing "kubectl_aliases.sh"
add_source_if_missing "azdo_done.sh"

echo "[INFO] Installation complete. Reload your shell:"
echo "  source $CONFIG_FILE"