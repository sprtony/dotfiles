# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

# Variables específicas de este Mac (rutas en /Volumes/Data)
export CHROME_EXECUTABLE="/Volumes/Data/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
export HERD_PHP_84_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/84/"
export NVM_DIR="$HOME/Library/Application Support/Herd/config/nvm"

# Variables compartidas (pnpm, cargo, opencode, secretos)
if [ -f ~/.shared_env ]; then
  . ~/.shared_env
fi

# p10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# PATH específico de macOS
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"
export PATH="/Volumes/Data/flutter/bin:$PATH"
export PATH="$HOME/.pub-cache/bin:$PATH"
export PATH="$HOME/Library/Python/3.9/bin:$PATH"
export PATH="/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin:$PATH"
export PATH="/Volumes/Data/Applications/calibre.app/Contents/MacOS:$PATH"
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
export PATH="$HOME/Library/Application Support/Herd/bin:$PATH"

# Android SDK (migrado a /Volumes/Data; symlink en ~/Library/Android/sdk)
export ANDROID_HOME="/Volumes/Data/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"

# Plugins
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"
plug "romkatv/powerlevel10k"
plug "lukechilds/zsh-nvm"
plug "hcgraf/zsh-sudo"

# rbenv
eval "$(rbenv init -)"

# Herd NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[[ -f "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh" ]] && builtin source "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh"

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Docker CLI completions
fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
compinit

# Antigravity CLI installer
export PATH="$HOME/.antigravity-ide/antigravity-ide/bin:$PATH"

# Init común (aliases, p10k, mise, zoxide, fzf)
[ -f ~/.config/shell/zsh-init.zsh ] && source ~/.config/shell/zsh-init.zsh
