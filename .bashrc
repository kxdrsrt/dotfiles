#!/bin/bash

# Environment Variables
export PROMPT='%F{green}🅺 @%m%f:%F{blue}%~%f '
export PATH=$HOME/bin:/usr/local/bin:$PATH # Adds custom directories to the PATH environment variable
export EDITOR=nano                         # Sets nano as the default text editor
export BROWSER=arc                         # Sets arc as the default web browser
HISTSIZE=1000                              # Limits the size of command history to 1000 entries
SAVEHIST=1000                              # Limits the size of saved history to 1000 entries
HISTFILE=~/.bash_history                   # Specifies the location of the command history file
HISTCONTROL=ignoredups                     # Ignore duplicate commands in history

# Options
# Extended globbing. Allows using regular expressions with *
shopt -s histappend      # Append new history entries to the history file instead of overwriting it
shopt -s autocd          # Allow switching to a directory by typing its name without cd command
shopt -s extglob         # Enable extended pattern matching features (e.g., using *(...) for complex patterns)
shopt -s nocaseglob      # Perform case-insensitive pattern matching
shopt -s globasciiranges # Sort filenames numerically when possible (e.g., file1.txt, file2.txt)

# Aliases - Directory Navigation
alias ..='cd ..'                                                  # Go up one directory
alias ...='cd ../..'                                              # Go up two directories
alias ....='cd ../../..'                                          # Go up three directories
alias ~='cd ~'                                                    # Go to home directory
alias ahk="cd '/Users/k/Developer/AHK-SAP-SAG'"                   # Navigate to AHK-SAP-SAG directory
alias desk="cd ~/Desktop/"                                        # Navigate to Desktop directory
alias dev="cd ~/Developer/"                                       # Navigate to Developer directory
alias doc="cd ~/Documents/"                                       # Navigate to Documents directory
alias dow="cd ~/Downloads/"                                       # Navigate to Downloads directory
alias home="cd $HOME/"                                            # Navigate to Home directory
alias iCloud='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs' # Navigate to iCloud directory
alias k="cd $HOME/"                                               # Navigate to K's Home directory
alias wd="cd '/Users/k/Desktop/S AG'"                             # Navigate to S AG directory on Desktop

# Aliases - Common Commands
alias c="clear"                  # Clear terminal
alias cp='cp -i'                 # Confirm before overwriting files with cp
alias df='df -h'                 # Display human-readable disk space usage
alias grep='grep --color=auto'   # Colorful grep
alias h="history -10"            # Show last 10 history commands
alias hc="rm ~/.bash_history"    # Clear history
alias l='ls -CF'                 # List files in columns
alias la='ls -A'                 # List all files excluding . and ..
alias ll="ls -alF"               # List all files with detailed view
alias ls="ls --color -h"         # List with color and human-readable sizes
alias more=less                  # Use less instead of more
alias mv='mv -i'                 # Confirm before overwriting files with mv
alias rm='rm -rf'                # Remove files and directories without confirmation
alias rs='source ~/.bashrc'      # Refresh .bashrc
alias shutdown="shutdown -h now" # Shutdown the system
alias x="exit"                   # Exit terminal

# Aliases - Git Commands
alias g="git"             # Shortcut for git
alias ga="git add"        # Shortcut for git add
alias gaa="git add"       # Shortcut for git add (alternative)
alias gc="git clone"      # Shortcut for git clone
alias gcm="git commit -m" # Shortcut for git commit with message
alias gco="git checkout"  # Shortcut for git checkout
alias gpl="git pull"      # Shortcut for git pull
alias gps="git push"      # Shortcut for git push
alias gst="git status"    # Shortcut for git status

# Aliases - Homebrew Commands
alias bar="brew autoremove" # Remove unused dependencies
alias bc="brew cleanup"     # Remove outdated versions
alias bin="brew install"    # Install a Homebrew package
alias bug="brew upgrade"    # Upgrade all Homebrew packages
alias bu="brew update"      # Update Homebrew
alias bun="brew uninstall"  # Uninstall a Homebrew package

# Aliases - Miscellaneous Commands
alias dark='osascript -e "tell app \"System Events\" to tell appearance preferences to set dark mode to not dark mode"' # Toggle Dark Mode
alias myip='echo "Public IP: $(curl -4 -s http://ipecho.net/plain)"; echo "Local IP: $(ipconfig getifaddr en0)"'        # Get public IPv4 and local IP addresses
alias python="/usr/bin/python3"                                                                                         # Use Python 3 by default
alias resetkeyboard="sudo sh ~/Documents/Others/macOS/keys-swapped.sh"                                                  # Reset keyboard plist
alias spotx="bash <(curl -sSL https://raw.githubusercontent.com/Nuzair46/BlockTheSpot-Mac/main/install.sh)"             # Install SpotX

# Aliases - Scripts
alias icns2png="sh $HOME/Documents/Others/macOS/Scripts/icns2png.sh"     # Convert icns to png
alias mac-deploy="sh $HOME/Documents/Others/macOS/Scripts/mac-deploy.sh" # Mac deployment script
alias png2icns="sh $HOME/Documents/Others/macOS/Scripts/png2icns.sh"     # Convert png to icns

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

# Load completion modules
autoload -Uz compinit
compinit
