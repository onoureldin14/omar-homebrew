# 🧰 Dev Aliases for Terraform, Terragrunt, and Kubernetes

This repository contains convenient aliases and helper functions for commonly used CLI tools:

* **Terraform**
* **Terragrunt**
* **Kubernetes (`kubectl`)**
* **Git automation** with `azdo-done`

These aliases improve developer productivity by shortening frequently used commands and adding contextual helper functions (like `k -h`).

---

## ⚡️ Quick Install (No Homebrew Required)

Run this one-liner to install everything:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/onoureldin14/omar-homebrew/main/install.sh)
```

This will:

* Download all alias/helper scripts to `~/.dotfiles`
* Automatically update your `~/.zshrc` to source them
* Ensure `jq` and `pre-commit` are installed via Homebrew

Then apply the changes:

```bash
source ~/.zshrc
```

---

## 📦 Contents

```bash
aliases/
├── terraform_aliases.sh     # Terraform shortcuts (e.g., tfi, tfp, tfa)
├── terragrunt_aliases.sh    # Terragrunt shortcuts (e.g., tgi, tgp, tga)
├── kubectl_aliases.sh       # Kubernetes shortcuts (e.g., kgp, kaf, k-h)
└── azdo_done.sh             # Git helper function to commit and create PRs
install.sh                   # Installer script
README.md
```

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
