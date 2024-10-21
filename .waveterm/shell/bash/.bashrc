
# Source /etc/profile if it exists
if [ -f /etc/profile ]; then
    . /etc/profile
fi

# Source the first of ~/.bash_profile, ~/.bash_login, or ~/.profile that exists
if [ -f ~/.bash_profile ]; then
    . ~/.bash_profile
elif [ -f ~/.bash_login ]; then
    . ~/.bash_login
elif [ -f ~/.profile ]; then
    . ~/.profile
fi

export PATH="$WAVETERM_WSHBINDIR":$PATH
if type _init_completion &>/dev/null; then
  source <(wsh completion bash)
fi

