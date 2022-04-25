if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export EDITOR="nvim"
export TERM="xterm-256color"

#Variables personales
export ComposerPath=$HOME/.composer/vendor/bin
export CURLPath=/usr/local/opt/curl/bin
export ANDROID_HOME=$HOME/Library/Android/sdk
export FLUTTER_HOME=$HOME/Library/flutter/bin
export PATH=$HOME/bin:/usr/local/bin:$CURLPath:$ComposerPath:$FLUTTER_HOME:$PATH


export ZSH="/Users/tony/.oh-my-zsh"

#configuraciones powerlevel9k
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
	zsh-nvm
	git
	brew
	colorize
	colored-man-pages
	compleat
	composer
	copypath
	copyfile
	cp
	copybuffer
	docker
	github
	gitignore
	iterm2
	laravel
	npm
	node
	macos
	sudo
	yarn
	zsh-autosuggestions
	zsh-syntax-highlighting
	zsh-completions
	history-substring-search
    )
autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
