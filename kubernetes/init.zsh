#
# Provides 'kubectl' aliases and utiities.
#
# Authors:
#   Bruno Miguel Custodio <brunomcustodio@gmail.com>
#

# Return if requirements are not found.
if (( ! ${+commands[kubectl]} )); then
  return 1
fi

# Enable completion for 'kubectl'.
cache_file="${0:h}/cache.zsh"
kubectl_command="${commands[kubectl]}"

if [[ "${kubectl_command}" -nt "${cache_file}" || ! -s "${cache_file}" ]]; then
  ${kubectl_command} completion zsh >! "${cache_file}" 2> /dev/null
fi

source "${cache_file}"
unset cache_file kubectl_command

#
# Aliases
#

alias kb='kubectl'

alias kba='kubectl apply'
alias kbc='kubectl config'
alias kbcg='kubectl config get-contexts'
alias kbcu='kubectl config use-context'
alias kbcv='kubectl config view'
alias kbC='kubectl create'
alias kbD='kubectl delete'
alias kbd='kubectl describe'
alias kbe='kubectl exec'
alias kbf='kubectl port-forward'
alias kbg='kubectl get'
alias kbgpa='kubectl get po --all-namespaces'
alias kbl='kubectl logs'
alias kblf='kubectl logs --follow'
alias kbr='kubectl run'
alias kbpn='kubectl get pod -o=custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName'

alias wkb='watch -n 1 kubectl'

kbn () {
  kubectl config set-context $(kubectl config current-context) --namespace=$1
}

kbcani()    {
  local serviceaccount_namespace=$1
  shift
  local serviceaccount=$1
  shift

  kubectl auth can-i --as=system:serviceaccount:$serviceaccount_namespace:$serviceaccount $@
}

check_roles_serviceaccount_bindings()   {
  kubectl get rolebindings,clusterrolebindings \
    --all-namespaces  \
    -o custom-columns='KIND:kind,NAMESPACE:metadata.namespace,NAME:metadata.name,SERVICE_ACCOUNTS:subjects[?(@.kind=="ServiceAccount")].name'
}

# name formatting
zstyle ':prezto:module:contrib-kubernetes' dev-clusters-default 'dev'
