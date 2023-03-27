if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export _JAVA_AWT_WM_NONREPARENTING=1
export EDITOR="nvim"
export TERM="xterm-kitty"
export CHROME_EXECUTABLE="google-chrome-stable"

export ANDROID_HOME="/opt/android"
export JAVA_HOME="/opt/openjdk/jdk-11.0.18+10"

#Mis Variables
export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
export PATH="$HOME/.cargo/env:$PATH"
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
export PATH="/opt/flutter/bin/:$PATH"
export PATH="/opt/go/bin:$HOME/go/bin/:$PATH"

export PATH="$ANDROID_HOME/cmdline-tools/tools/bin:$PATH"
export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$JAVA_HOME/bin:$PATH"



export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'

plugins=(
	sudo

	colorize
	colored-man-pages

	copypath
	copyfile
	cp
	copybuffer
	docker

	git
	github
	gitignore

	laravel

	zsh-nvm
	npm
	node
	yarn

	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Example aliases
alias ls="lsd"
alias cat="bat"
# alias git_efe_push="git ftp push -u root --key ~/.ssh/id_rsa sftp://calzadoefe.com/var/www/efe"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
