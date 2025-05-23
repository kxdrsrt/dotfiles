# Environment Variables
export PROMPT='%F{green}🅺 @%m%f:%F{blue}%~%f ' # Customizes the terminal prompt format
export PATH=$HOME/bin:/usr/local/bin:$PATH     # Adds custom directories to the PATH environment variable
export EDITOR=nano                             # Sets nano as the default text editor
export BROWSER=arc                             # Sets arc as the default web browser
export HOMEBREW_NO_QUARANTINE=1                # Disable Homebrew quarantine for security
HISTSIZE=1000                                  # Limits the size of command history to 1000 entries
SAVEHIST=1000                                  # Limits the size of saved history to 1000 entries
HISTFILE=~/.zsh_history                        # Specifies the location of the command history file

# Python Variables
export PATH="/opt/homebrew/opt/python@3.12/bin:$PATH"
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"

# Options
setopt autocd          # Allow switching to a directory by typing its name without cd command
setopt extendedglob    # Enable extended pattern matching features (e.g., using *(...) for complex patterns)
setopt nocaseglob      # Perform case-insensitive pattern matching
setopt numericglobsort # Sort filenames numerically when possible (e.g., file1.txt, file2.txt)
setopt rcexpandparam   # Perform parameter expansion on words resulting from filename generation

# Aliases - Directory Navigation
alias ..='cd ..'                                                                                                         # Navigate up one directory level
alias ...='cd ../..'                                                                                                     # Navigate up two directory levels
alias ....='cd ../../..'                                                                                                 # Navigate up three directory levels
alias ~='cd ~'                                                                                                           # Navigate to home directory
alias ahk='cd ~/Library/CloudStorage/OneDrive-SiemensAG/Dokumente/Coding/sag-ahk-sap'                                    # Navigate to AHK-SAP-SAG directory
alias desk='cd ~/Desktop/'                                                                                               # Navigate to Desktop directory
alias dev='cd ~/Developer/'                                                                                              # Navigate to Developer directory
alias doc='cd ~/Documents/'                                                                                              # Navigate to Documents directory
alias dow='cd ~/Downloads/'                                                                                              # Navigate to Downloads directory
alias home='cd ~/'                                                                                                       # Navigate to Home directory
alias iCloud='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'                                                        # Navigate to iCloud directory
alias k='cd ~/'                                                                                                          # Navigate to K's Home directory
alias wd='cd ~/Documents/Work\ \&\ Career/Work/SIEMENS\ AG/Werkstudent\ Programmierung\ ID-411626/0\ Working\ Directory' # Navigate to SAG Working Directory
alias xa='cd ~/Developer/xathena'                                                                                        # Navigate to xathena directory


# Aliases - Common Commands
alias c='clear'                  # Clear terminal
alias cp='cp -I'                 # Confirm before overwriting files with cp
alias df='df -h'                 # Display human-readable disk space usage
alias grep='grep --color=auto'   # Colorful grep
alias h='history -10'            # Show last 10 history commands
alias hc='rm ~/.zsh_history'     # Clear history
alias l='ls -CF'                 # List files in columns
alias la='ls -A'                 # List all files excluding . and ..
alias ll='ls -alF'               # List all files with detailed view
alias ls='ls --color -h'         # List with color and human-readable sizes
alias more='less'                # Use less instead of more
alias o='open .'                 # Open the current directory in Finder
alias mv='mv -I'                 # Confirm before overwriting files with mv
alias rm='rm -rf'                # Remove files and directories without confirmation
alias rs='source ~/.zshrc'       # Refresh .zshrc
alias shutdown='shutdown -h now' # Shutdown the system
alias x='exit'                   # Exit terminal

# Aliases - Git Commands
alias g='git'                                                           # Shortcut for git
alias ga='git add'                                                      # Shortcut for git add
alias ga.='git add .'                                                   # Shortcut for git add (alternative)
alias gap='git add . && git commit -m "Updated .gitignore" && git push' # Add, commit and push at once.
alias gc='git clone'                                                    # Shortcut for git clone
alias gcf='git clean -fv'                                               # Shortcut for forceful removal of untracked files with verbose output
alias gcm='git commit -m'                                               # Shortcut for git commit with message
alias gco='git checkout'                                                # Shortcut for git checkout
alias gp='git pull'                                                     # Shortcut for git pull
alias gup='git push'                                                    # Shortcut for git push
alias gr='git restore .'                                                # Shortcut for git restore to discard changes to tracked files
alias gs='git status'                                                   # Shortcut for git status
alias gstk='git stash --keep-index'                                     # Shortcut for git status
alias gstku='git stash --keep-index -u'                                      # Shortcut for git status


# Aliases - Homebrew Commands
alias bar='brew autoremove'        # Remove unused dependencies
alias bc='brew cleanup'            # Remove outdated versions
alias bin='brew install'           # Install a Homebrew package
alias bre='brew reinstall'         # Reinstall a Homebrew package
alias bug='brew upgrade'           # Upgrade all Homebrew packages
alias bugg='brew upgrade --greedy' # Upgrade all (Homebrew) packages and dependencies
alias bu='brew update'             # Update Homebrew
alias bun='brew uninstall'         # Uninstall a Homebrew package

# Aliases - Miscellaneous Commands
alias battery="system_profiler SPPowerDataType | grep 'Cycle Count\|Condition\|State of Charge\|Power Source State\|Maximum Capacity' | grep -v 'Health Information' | sed $'s/Cycle Count:/\x1b[1;31mCycle Count:\x1b[0m/g'"
alias betterdisplay="rm -rf /Users/k/Library/Preferences/pro.betterdisplay.BetterDisplay.plist"
alias cork="rm -rf /Users/k/Library/Preferences/com.davidbures.Cork.plist"
alias cursor-trial='curl -sL dub.sh/cursorreset | python3'                                                              # Cursor Trial Reset
alias cursor-reset='curl -fsSL https://aizaozao.com/accelerate.php/https://raw.githubusercontent.com/yuaotian/go-cursor-help/refs/heads/master/scripts/run/cursor_mac_id_modifier.sh -o ./cursor_mac_id_modifier.sh && sudo bash ./cursor_mac_id_modifier.sh && rm ./cursor_mac_id_modifier.sh'
alias dark='osascript -e "tell app \"System Events\" to tell appearance preferences to set dark mode to not dark mode"' # Toggle Dark Mode
alias dhcp='sudo ifconfig en0 down && sudo ifconfig en0 up'                                                             # Reset DHCP completely
alias myip='echo "Public IP: $(curl -4 -s http://ipecho.net/plain)"; echo "Local IP: $(ipconfig getifaddr en0)"'        # Get public IPv4 and local IP addresses
alias resetkeyboard='sudo sh ~/Documents/Others/macOS/keys-swapped.sh'                                                  # Reset keyboard plist
alias spotx='bash <(curl -sSL https://spotx-official.github.io/run.sh) -B -c -f -h'                                     # Install SpotX
alias wifiinfo='networksetup -listallnetworkservices | grep -i wi-fi | xargs -I {} sh -c '\''echo "Service: {}"; networksetup -getinfo "{}"; echo "MAC Address: $(networksetup -getmacaddress "{}" | awk "{print \$3}")"'\'''

# Aliases - Scripts
alias icns2png='sh $HOME/Documents/Others/macOS/Scripts/icns2png.sh'     # Convert icns to png
alias lpm='$HOME/Documents/Others/macOS/Scripts/toggle-lpm.sh'           # Toggle Low Power Mode
alias mac-deploy='sh $HOME/Documents/Others/macOS/Scripts/mac-deploy.sh' # Mac deployment script
alias md2pdf='sh $HOME/Documents/Others/macOS/Scripts/md2pdf.sh'         # Convert Markdown to PDF
alias png2icns='sh $HOME/Documents/Others/macOS/Scripts/png2icns.sh'     # Convert png to icns

# Aliases - SSH Servers
# Alias for connecting to RO VPS as user k
alias ro='ssh k@ro-server'

# Alias for connecting to RO VPS as root
alias roo='ssh root@ro-server'

# Functions
function - {
    cd -
}

# Function to mimic `cd -`
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Remove existing aliases that might conflict with function names
unalias extract 2>/dev/null
unalias create_zip 2>/dev/null

# Function to extract various types of archives
extract() {
    if [ -f "$1" ]; then
        case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz) tar xzf "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.rar) unrar x "$1" ;;
        *.gz) gunzip "$1" ;;
        *.tar) tar xvf "$1" ;;
        *.tbz2) tar xjf "$1" ;;
        *.tgz) tar xzf "$1" ;;
        *.zip) unzip "$1" ;;
        *.Z) uncompress "$1" ;;
        *.7z) 7z x "$1" ;;
        *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Function to create a zip archive from a file or directory
create_zip() {
    if [ -d "$1" ]; then
        zip -r "${1%/}.zip" "$1"
    elif [ -f "$1" ]; then
        zip "${1}.zip" "$1"
    else
        echo "'$1' is not a valid file or directory"
    fi
}

# Alias to extract archives
alias extract='extract'

# Alias to create zip archives
alias zip='create_zip'

# Aliases - Miscellaneous Commands
alias unquarantine='xattr -dr com.apple.quarantine' # Use as: unquarantine /path/to/app
alias unquarantine-apps='sudo xattr -dr com.apple.quarantine /Applications/*.app' # Remove quarantine from all apps, including those in subdirectories
