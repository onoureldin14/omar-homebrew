# 🧰 Dev Aliases for Terraform, Terragrunt, and Kubernetes

This repository contains convenient aliases and helper functions for commonly used CLI tools:

* **Terraform**
* **Terragrunt**
* **Kubernetes (`kubectl`)**
* **Git automation** with `azdo-done`

These aliases improve developer productivity by shortening frequently used commands and adding contextual helper functions (like `k -h`).

---

## 📦 Contents

```bash
aliases/
├── terraform_aliases.sh     # Terraform shortcuts (e.g., tfi, tfp, tfa)
├── terragrunt_aliases.sh    # Terragrunt shortcuts (e.g., tgi, tgp, tga)
├── kubectl_aliases.sh       # Kubernetes shortcuts (e.g., kgp, kaf, k-h)
└── azdo_done.sh             # Git helper function to commit and create PRs
install.sh                   # Installer script used by Homebrew
```

---

## ✨ Setup via Homebrew (Preferred)

### 1. Create and Structure Your Repo

You already created: `https://github.com/onoureldin14/omar-homebrew`

In your repo, structure the contents as:

```bash
omar-homebrew/
├── aliases/
│   ├── terraform_aliases.sh
│   ├── terragrunt_aliases.sh
│   ├── kubectl_aliases.sh
│   └── azdo_done.sh
└── install.sh               # Main install script
```

### 2. Write the `install.sh` Script

Create a file `install.sh` with the following content:

```bash
#!/bin/bash

set -e

REPO="https://raw.githubusercontent.com/onoureldin14/omar-homebrew/main"
CACHE_DIR="$HOME/.dotfiles"

mkdir -p "$CACHE_DIR"

echo "[INFO] Downloading alias files..."
curl -fsSL "$REPO/aliases/terraform_aliases.sh" -o "$CACHE_DIR/terraform_aliases.sh"
curl -fsSL "$REPO/aliases/terragrunt_aliases.sh" -o "$CACHE_DIR/terragrunt_aliases.sh"
curl -fsSL "$REPO/aliases/kubectl_aliases.sh" -o "$CACHE_DIR/kubectl_aliases.sh"
curl -fsSL "$REPO/aliases/azdo_done.sh" -o "$CACHE_DIR/azdo_done.sh"

CONFIG_FILE="$HOME/.zshrc"
echo "[INFO] Updating $CONFIG_FILE..."
grep -q 'source ~/.dotfiles/terraform_aliases.sh' "$CONFIG_FILE" || {
  echo "" >> "$CONFIG_FILE"
  echo "# Dotfiles aliases" >> "$CONFIG_FILE"
  echo "source ~/.dotfiles/terraform_aliases.sh" >> "$CONFIG_FILE"
  echo "source ~/.dotfiles/terragrunt_aliases.sh" >> "$CONFIG_FILE"
  echo "source ~/.dotfiles/kubectl_aliases.sh" >> "$CONFIG_FILE"
  echo "source ~/.dotfiles/azdo_done.sh" >> "$CONFIG_FILE"
}

echo "[DONE] Aliases installed. Run: source ~/.zshrc"
```

Make it executable:

```bash
chmod +x install.sh
```

### 3. Create the Homebrew Tap and Install

```bash
brew tap onoureldin14/omar-homebrew https://github.com/onoureldin14/omar-homebrew.git
brew install omar-homebrew
```

**Note:** Create a symlink to simulate the formula:

```bash
ln -s install.sh omar-homebrew
```

You can now run:

```bash
brew install omar-homebrew
```

This will:

* Download and cache alias files to `~/.dotfiles`
* Append them to your shell config (`~/.zshrc`)
* Allow automatic updates via `git push` to your GitHub repo

---

## 🛠️ Available Aliases

### Terraform

| Alias | Command           |
| ----- | ----------------- |
| `tf`  | `terraform`       |
| `tfi` | `terraform init`  |
| `tfp` | `terraform plan`  |
| `tfa` | `terraform apply` |

---

### Terragrunt

| Alias | Command            |
| ----- | ------------------ |
| `tg`  | `terragrunt`       |
| `tgi` | `terragrunt init`  |
| `tgp` | `terragrunt plan`  |
| `tga` | `terragrunt apply` |

---

### Kubernetes

| Alias  | Command                                            |
| ------ | -------------------------------------------------- |
| `k`    | `kubectl`                                          |
| `kgp`  | `kubectl get pods`                                 |
| `kgs`  | `kubectl get svc`                                  |
| `kgn`  | `kubectl get nodes`                                |
| `kgd`  | `kubectl get deployments`                          |
| `kdp`  | `kubectl describe pod`                             |
| `kds`  | `kubectl describe svc`                             |
| `kd`   | `kubectl describe`                                 |
| `kl`   | `kubectl logs`                                     |
| `kaf`  | `kubectl apply -f`                                 |
| `kdf`  | `kubectl delete -f`                                |
| `kctx` | `kubectl config use-context`                       |
| `kns`  | `kubectl config set-context --current --namespace` |
| `k -h` | Displays a help menu with usage                    |

---

### Git / Azure DevOps

| Function    | Description                                                                                        |
| ----------- | -------------------------------------------------------------------------------------------------- |
| `azdo-done` | Automates commit, push, and PR creation (uses `pr.md`). Installs `pre-commit` and `jq` if missing. |

> First-time use will prompt for an Azure DevOps Personal Access Token and save it locally.

---

## 📄 License

MIT © Omar Din
