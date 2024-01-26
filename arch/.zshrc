# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

# p10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#Mis Variables
export _JAVA_AWT_WM_NONREPARENTING=1
export EDITOR="nvim"
export TERM="xterm-256color"
#export CHROME_EXECUTABLE="google-chrome-stable"
#export $BROWSER=$CHROME_EXECUTABLE
export ANDROID_HOME="$HOME/Programas/android"
export JAVA_HOME="$HOME/Programas/openjdk/jdk-11.0.18+10"

#PATH
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
export PATH="$HOME/.cargo/env:$PATH"
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
export PATH="$HOME/Programas/flutter/bin/:$PATH"
export PATH="$HOME/Programas/go/bin:$HOME/go/bin/:$PATH"
export PATH="$HOME/Programas/AndroidStudio/bin/:$PATH"
export PATH="$ANDROID_HOME/cmdline-tools/tools/bin:$PATH"
export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"

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

# bun completions
[ -s "/home/quimaira/.bun/_bun" ] && source "/home/quimaira/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
