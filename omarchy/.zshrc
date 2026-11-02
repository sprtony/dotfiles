# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

# Variables compartidas (pnpm, cargo, opencode, secretos)
if [ -f ~/.shared_env ]; then
  . ~/.shared_env
fi

# p10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Plugins
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"
plug "romkatv/powerlevel10k"
plug "hcgraf/zsh-sudo"

# Alias específicos de Omarchy
alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'

# Init común (aliases, p10k, mise, zoxide, fzf)
[ -f ~/.config/shell/zsh-init.zsh ] && source ~/.config/shell/zsh-init.zsh
