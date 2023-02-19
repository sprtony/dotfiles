if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export _JAVA_AWT_WM_NONREPARENTING=1
export EDITOR="nvim"
export TERM="xterm-kitty"
export CHROME_EXECUTABLE=google-chrome-stable

#Mis Variables
export ComposerPath=$HOME/.config/composer/vendor/bin
export ANDROID_HOME=$HOME/Android/Sdk
export FLUTTER_HOME=/opt/flutter/bin
export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:$CURLPath:$ComposerPath:$FLUTTER_HOME:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'

plugins=(
	sudo
	archlinux

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
	fzf-zsh-plugin
)

source $ZSH/oh-my-zsh.sh

# Example aliases
alias ls="lsd"
alias cat="bat"
# alias git_efe_push="git ftp push -u root --key ~/.ssh/id_rsa sftp://calzadoefe.com/var/www/efe"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
