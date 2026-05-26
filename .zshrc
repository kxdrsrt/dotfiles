# ─── Environment ──────────────────────────────────────────────────────────────
export PROMPT='%F{green}🅺 @%m%f:%F{blue}%~%f '
export EDITOR=nano
export BROWSER="open -a Dia"
export HOMEBREW_NO_QUARANTINE=1
export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include"

# PATH (deduplicated via typeset -U)
typeset -U PATH
export PATH="$HOME/bin:$PATH"

# ─── History ──────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

# ─── Options ─────────────────────────────────────────────────────────────────
setopt autocd
setopt extendedglob
setopt nocaseglob
setopt numericglobsort
setopt rcexpandparam

# ─── Navigation ───────────────────────────────────────────────────────────────
alias ..='cd ..'                # Navigate up one level
alias ...='cd ../..'             # Navigate up two levels
alias ....='cd ../../..'         # Navigate up three levels
alias {~,home,k}='cd ~'          # Navigate to home directory
alias desk='cd ~/Desktop'        # Navigate to Desktop
alias dev='cd ~/Developer'       # Navigate to Developer
alias doc='cd ~/Documents'       # Navigate to Documents
alias dow='cd ~/Downloads'       # Navigate to Downloads
alias iCloud='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'
alias ahk='cd ~/Library/CloudStorage/OneDrive-SiemensAG/Dokumente/Coding/sag-ahk-sap'
alias wd='cd ~/Documents/Work\ \&\ Career/Work/SIEMENS\ AG/Werkstudent\ Programmierung\ ID-411626/0\ Working\ Directory'
alias xa='cd ~/Developer/xathena'

# ─── Common Commands ─────────────────────────────────────────────────────────
alias c='clear'                  # Clear terminal
alias cp='cp -i'                 # Confirm before overwriting
alias mv='mv -i'                 # Confirm before overwriting
alias rm='rm -i'                 # Safe default; use \rm -rf when you mean it
alias df='df -h'                 # Human-readable disk usage
alias grep='grep --color=auto'   # Colorful grep
alias h='history -10'            # Show last 10 history commands
alias l='ls -CF'                 # List files in columns
alias la='ls -A'                 # List all except . and ..
alias ll='ls -alF'               # Detailed file listing
alias ls='ls -Gh'                # Color + human-readable sizes (macOS)
alias o='open .'                 # Open current dir in Finder
alias x='exit'                   # Exit terminal
alias rs='source ~/.zshrc'       # Reload shell config
alias shutdown='sudo shutdown -h now' # Shutdown the system
alias dia='open -a Dia'          # Launch Dia browser
alias dark='osascript -e "tell app \"System Events\" to tell appearance preferences to set dark mode to not dark mode"' # Toggle dark mode
alias unquarantine='xattr -dr com.apple.quarantine'              # Remove quarantine from a file/app
alias unquarantine-apps='sudo xattr -dr com.apple.quarantine /Applications/*.app' # Remove quarantine from all apps

# ─── Git ──────────────────────────────────────────────────────────────────────
alias g='git'
alias ga='git add'
alias ga.='git add .'
alias gap='git add . && git commit && git push' # Add, commit (opens editor), push
alias gc='git clone'
alias gcf='git clean -fv'
alias gcm='git commit -m'
alias gco='git checkout'
alias gp='git pull'
alias gup='git push'
alias gr='git restore'           # Usage: gr <file> (no accidental wipe)
alias gs='git status'
alias gstk='git stash --keep-index'
alias gstku='git stash --keep-index -u'

# ─── Homebrew ─────────────────────────────────────────────────────────────────
alias bar='brew autoremove'
alias bc='brew cleanup --prune=0 -s && command rm -rf $(brew --cache)'
alias bin='brew install'
alias bre='brew reinstall'
alias bu='brew update'
alias bug='brew upgrade'
alias bugg='brew upgrade --greedy'
alias brm='brew uninstall'       # Renamed from bun to avoid conflict with Bun runtime

# ─── Nix ──────────────────────────────────────────────────────────────────────
alias nixre="sh ~/nix-darwin-config/redeploy.sh"
alias nixedit="code ~/nix-darwin-config"

# ─── SSH ──────────────────────────────────────────────────────────────────────
alias ro='ssh k@ro-server'
alias roo='ssh root@ro-server'
alias ye-pc='ssh ye-pc'
alias ye-pc-admin='ssh ye-pc-admin'

# ─── Network & System ────────────────────────────────────────────────────────
alias battery="system_profiler SPPowerDataType | grep 'Cycle Count\|Condition\|State of Charge\|Power Source State\|Maximum Capacity' | grep -v 'Health Information' | sed $'s/Cycle Count:/\x1b[1;31mCycle Count:\x1b[0m/g'"
alias dhcp='sudo ifconfig en0 down && sudo ifconfig en0 up'
alias myip='echo "Public IP: $(curl -4 -s http://ipecho.net/plain)"; echo "Local IP: $(ipconfig getifaddr en0)"'
alias wifiinfo='networksetup -listallnetworkservices | grep -i wi-fi | xargs -I {} sh -c '\''echo "Service: {}"; networksetup -getinfo "{}"; echo "MAC Address: $(networksetup -getmacaddress "{}" | awk "{print \$3}")"'\'''

# ─── Scripts ──────────────────────────────────────────────────────────────────
alias icns2png='sh "$HOME/Documents/6 Others/macOS/Scripts/icns2png.sh"'
alias lpm='sh "$HOME/Documents/6 Others/macOS/Scripts/toggle-lpm.sh"'
alias mac-deploy='sh "$HOME/Documents/6 Others/macOS/Scripts/mac-deploy.sh"'
alias md2pdf='sh "$HOME/Documents/6 Others/macOS/Scripts/md2pdf.sh"'
alias png2icns='sh "$HOME/Documents/6 Others/macOS/Scripts/png2icns.sh"'
alias awdl='bash <(curl -sL https://www.meter.com/awdl.sh)'
alias awdld='curl -sL https://www.meter.com/awdl-daemon.sh | bash'
alias awdl-restore='curl -s https://raw.githubusercontent.com/meterup/awdl_wifi_scripts/main/cleanup-and-reenable-awdl.sh | bash &> /dev/null'

# ─── App Resets & Tools ───────────────────────────────────────────────────────
alias betterdisplay="command rm -rf ~/Library/Preferences/pro.betterdisplay.BetterDisplay.plist"
alias cork="command rm -rf ~/Library/Preferences/com.davidbures.Cork.plist"
alias cursor-trial='curl -sL dub.sh/cursorreset | python3'
alias cursor-reset='curl -fsSL https://aizaozao.com/accelerate.php/https://raw.githubusercontent.com/yuaotian/go-cursor-help/refs/heads/master/scripts/run/cursor_mac_id_modifier.sh -o ./cursor_mac_id_modifier.sh && sudo bash ./cursor_mac_id_modifier.sh && rm ./cursor_mac_id_modifier.sh'
alias spotx='bash <(curl -sSL https://spotx-official.github.io/run.sh) -B -c -f -h'
alias resetkeyboard='sudo sh ~/Documents/Others/macOS/keys-swapped.sh'

# ─── Functions ────────────────────────────────────────────────────────────────
mkcd() { mkdir -p "$1" && cd "$1"; }

extract() {
    if [[ ! -f "$1" ]]; then
        echo "'$1' is not a valid file" >&2
        return 1
    fi
    case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz)  tar xzf "$1" ;;
        *.bz2)     bunzip2 "$1" ;;
        *.rar)     unrar x "$1" ;;
        *.gz)      gunzip "$1" ;;
        *.tar)     tar xvf "$1" ;;
        *.tbz2)    tar xjf "$1" ;;
        *.tgz)     tar xzf "$1" ;;
        *.zip)     unzip "$1" ;;
        *.Z)       uncompress "$1" ;;
        *.7z)      7z x "$1" ;;
        *) echo "'$1' cannot be extracted via extract()" >&2; return 1 ;;
    esac
}

create_zip() {
    if [[ -d "$1" ]]; then
        zip -r "${1%/}.zip" "$1"
    elif [[ -f "$1" ]]; then
        zip "${1}.zip" "$1"
    else
        echo "'$1' is not a valid file or directory" >&2
        return 1
    fi
}

# ─── Tool Integrations ───────────────────────────────────────────────────────
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
