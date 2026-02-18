# ===== Performance Optimizations =====
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"

# ===== Visual Tweaks =====
# Show fastfetch on new shell (outside tmux)
if [ -z "$TMUX" ] && [ -t 0 ]; then
    fastfetch --config ascii-color-fill ~/.config/fastfetch/config.jsonc 2>/dev/null || fastfetch
fi

# Colored output
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'
export LS_COLORS='di=1;34:ln=1;36:pi=33:so=35:bd=33:cd=34:ex=1;32:*.tar=31:*.tgz=31:*.arj=31:*.taz=31:*.lzh=31:*.zip=31:*.z=31:*.Z=31:*.gz=31:*.bz2=31:*.deb=31:*.rpm=31:*.jar=31:*.jpg=35:*.jpeg=35:*.gif=35:*.bmp=35:*.ppm=35:*.tar.gz=31:*.tar.bz2=31'

# Colored man pages
export MANPAGER='less -R --use-color -Dd+r -Du+b'

# Git status colors
ZSH_THEME_GIT_PROMPT_PREFIX=" %F{green}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{red}✗%f"
ZSH_THEME_GIT_PROMPT_CLEAN=" %F{green}✓%f"
ZSH_THEME_GIT_PROMPT_ADDED="%F{green}+%f"
ZSH_THEME_GIT_PROMPT_MODIFIED="%F{yellow}∼%f"
ZSH_THEME_GIT_PROMPT_DELETED="%F{red}−%f"

if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [ -t 0 ]; then
  tmux attach -t main || tmux new -s main
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export RBENV_ROOT="$HOME/.rbenv"
export PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"
eval "$(rbenv init - zsh)"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="amuse"

# Custom prompt character
PROMPT_CHAR="❯"

# Right-side prompt with git status
RPROMPT='%F{cyan}%T%f %F{yellow}%n@%m%f %F{green}$(git_prompt_info)%F{blue}%~%f'

plugins=(
	git
	zsh-syntax-highlighting
	zsh-bat z
	npm node yarn web-search extract
	zsh-autocomplete
)

# Only load docker plugins if docker is installed
if command -v docker &> /dev/null; then
  plugins+=(docker docker-compose)
fi

source $ZSH/oh-my-zsh.sh

source $HOME/.oh-my-zsh/custom/plugins/zsh-histdb/sqlite-history.zsh
autoload -Uz add-zsh-hook

export FLYCTL_INSTALL="/home/lukashdias/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

eval "$(~/.local/bin/mise activate zsh)"

export PATH=/home/lukashdias/.opencode/bin:$PATH

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

zstyle ':autocomplete:*' min-input 1
zstyle ':autocomplete:*' max-choices 10
zstyle ':autocomplete:*' delay 0.1
zstyle ':autocomplete:*' insert-unambiguous yes
zstyle ':autocomplete:*' widget-style menu-select

[ -f ~/.dircolors ] && eval $(dircolors -b ~/.dircolors)

alias ls='eza --icons'
alias ll='eza -la --icons --git'
alias l='eza -la --icons --git'
alias lt='eza --tree --level=2 --icons'
alias la='eza -a --icons'

alias sysinfo='~/.local/bin/fastfetch'

export PNPM_HOME="/home/lukashdias/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
export PATH="$HOME/bin:$PATH"

[ -s "/home/lukashdias/.bun/_bun" ] && source "/home/lukashdias/.bun/_bun"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"

# Start atuin daemon for history sync (only if not already running)
pgrep -f "atuin daemon" >/dev/null 2>&1 || atuin daemon &!

export PATH="/mnt/c/Users/diasl/AppData/Local/Programs/Microsoft VS Code/bin:/mnt/c/Program Files/cursor/resources/app/codeBin:$PATH"

alias code="/mnt/c/Users/diasl/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code"
alias cursor="/mnt/c/Program\ Files/cursor/Cursor.exe"

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'batcat --color=always {}' --preview-window=right:60%"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 {}'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window=down:3:wrap"

# ===== Zoxide - smart cd =====
eval "$(zoxide init zsh)"
# Use 'z' for smart jumping, 'cd' for normal navigation with tab completion

# ===== Atuin - improved history =====
eval "$(atuin init zsh)"
bindkey '^[[A' atuin-up-search
bindkey '^[[B' atuin-down-search

# ===== Better command aliases =====
alias grep='rg --smart-case'
alias cat='batcat --style=plain'
alias top='btm'
alias diff='delta'
alias vi='nvim'
alias vim='nvim'

# ===== LazyGit =====
alias lg='lazygit'

# ===== Tmux Helpers =====
alias tmux-keys='/usr/bin/grep -iE "split|pan|window|navigate" <<< "$(tmux list-keys)"'
alias tmux-sessions='tmux list-sessions'
alias tmux-windows='tmux list-windows'

# ===== WSL Integration =====
# Browser and file handlers for WSL
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
export LIBGL_ALWAYS_INDIRECT=1

# Smart open function for WSL - handles files, directories, and URLs
open() {
  local target="$1"
  if [ -z "$target" ]; then
    echo "Usage: open <file|directory|URL>"
    return 1
  fi
  
  # Use explorer.exe for everything in WSL (most reliable)
  if [[ "$target" =~ ^https?:// ]]; then
    # For URLs, use start command via cmd.exe
    cmd.exe /c start "" "$target" 2>/dev/null
  elif [ -d "$target" ]; then
    # For directories
    explorer.exe "$target" 2>/dev/null
  elif [ -f "$target" ]; then
    # For files
    explorer.exe "$target" 2>/dev/null
  else
    # Assume it's a URL or search query
    cmd.exe /c start "" "$target" 2>/dev/null
  fi
}

# Set BROWSER for tools that use it
export BROWSER="cmd.exe /c start"
export GIT_BROWSER="cmd.exe /c start"

# Alias xdg-open to use our open function
alias xdg-open='open'

# ===== Android SDK =====
# Point to Windows SDK (mounted in WSL) so Android Studio and Gradle agree on SDK location
export ANDROID_HOME="/mnt/c/Users/diasl/AppData/Local/Android/Sdk"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$ANDROID_HOME/build-tools/34.0.0:$PATH"

# ADB bridge to Windows Android Studio
export ADB_SERVER_SOCKET=tcp:$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):5037

# Load secrets (not tracked in git)
[[ -f ~/.secrets ]] && source ~/.secrets

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
