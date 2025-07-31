# Kubernetes (kubectl) aliases
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgn='kubectl get nodes'
alias kgd='kubectl get deployments'
alias kdp='kubectl describe pod'
alias kds='kubectl describe svc'
alias kd='kubectl describe'
alias kl='kubectl logs'
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'
alias kctx='kubectl config use-context'
alias kns='kubectl config set-context --current --namespace'

# Kubernetes help function
function k-help() {
  echo "
  Kubernetes Alias Cheat Sheet:

  k           = kubectl
  kgp         = kubectl get pods
  kgs         = kubectl get svc
  kgn         = kubectl get nodes
  kgd         = kubectl get deployments
  kdp <pod>   = kubectl describe pod <pod>
  kds <svc>   = kubectl describe svc <svc>
  kd <res>    = kubectl describe <res>
  kl <pod>    = kubectl logs <pod>
  kaf <file>  = kubectl apply -f <file>
  kdf <file>  = kubectl delete -f <file>
  kctx <ctx>  = kubectl config use-context <ctx>
  kns <ns>    = set current namespace

  Run: k -h
  "
}
alias k-h='k-help'