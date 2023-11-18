# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

# p10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#Mis Variables
export EDITOR="nvim"
export TERM="xterm-256color"
export BUN_INSTALL="$HOME/.bun"

#PATH
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
export PATH="$HOME/.cargo/env:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH="$HOME/Repos/flutter/bin/:$PATH"

export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="/usr/local/Cellar/ruby/3.2.2_1/bin:$PATH"

#plugins
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"
plug "romkatv/powerlevel10k"
plug "lukechilds/zsh-nvm"
plug "hcgraf/zsh-sudo"

#alias
alias ls="lsd"
alias cat="bat"

#load p10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# bun completions
[ -s "/home/quimaira/.bun/_bun" ] && source "/home/quimaira/.bun/_bun"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
