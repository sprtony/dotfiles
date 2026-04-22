# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

# Cargar variables compartidas
if [ -f ~/.shared_env ]; then
  . ~/.shared_env
fi

# p10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'

#load p10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if command -v mise &> /dev/null; then
  eval "$(mise activate zsh)"
fi

if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

if command -v fzf &> /dev/null; then
  if [[ -f /usr/share/bash-completion/completions/fzf ]]; then
    source /usr/share/bash-completion/completions/fzf
  fi
fi

# bun completions
[ -s "/home/quimaira/.bun/_bun" ] && source "/home/quimaira/.bun/_bun"
