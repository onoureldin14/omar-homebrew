#!/bin/bash

set -e

SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)/aliases"
CACHE_DIR="$HOME/.dotfiles"
CONFIG_FILE="$HOME/.zshrc"  # Change this to ~/.bashrc if needed

echo "📁 Syncing local aliases to $CACHE_DIR..."
mkdir -p "$CACHE_DIR"

for file in "$SOURCE_DIR"/*.sh; do
  filename=$(basename "$file")
  echo "   - Installing $filename"
  cp "$file" "$CACHE_DIR/$filename"
  chmod +x "$CACHE_DIR/$filename"
done

# Add source lines if not present
add_source_if_missing() {
  local file="$1"
  local line="source ~/.dotfiles/$file"
  if ! grep -Fxq "$line" "$CONFIG_FILE"; then
    echo "$line" >> "$CONFIG_FILE"
    echo "✅ Added $line to $CONFIG_FILE"
  else
    echo "ℹ️  $file already sourced in $CONFIG_FILE"
  fi
}

echo "🔧 Updating your shell config: $CONFIG_FILE"
echo -e "\n# Added by omar-homebrew install" >> "$CONFIG_FILE"
for file in "$CACHE_DIR"/*.sh; do
  filename=$(basename "$file")
  add_source_if_missing "$filename"
done

# Optional tools
for tool in jq pre-commit; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "[INFO] Installing missing dependency: $tool"
    if command -v brew >/dev/null 2>&1; then
      brew install "$tool"
    else
      echo "❌ $tool not found and Homebrew is not available. Please install it manually."
    fi
  fi
done

echo -e "\n✅ Local install complete."
echo "➡️  Run this to apply aliases now:"
echo "   source $CONFIG_FILE"