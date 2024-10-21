
# Source the original zshrc
[ -f ~/.zshrc ] && source ~/.zshrc

export PATH="$WAVETERM_WSHBINDIR":$PATH
if [[ -n ${_comps+x} ]]; then
  source <(wsh completion zsh)
fi
