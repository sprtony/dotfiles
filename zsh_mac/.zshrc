# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ComposerPath=$HOME/.composer/vendor/bin
export PHPPath=/usr/local/Cellar/php/7.4.2/bin
export CURLPath=/usr/local/opt/curl/bin
export ANDROID_HOME=$HOME/Library/Android/sdk
export FLUTTER_HOME=$HOME/Library/flutter/bin
export PATH=$HOME/bin:/usr/local/bin:$CURLPath:$PHPPath:$ComposerPath:$FLUTTER_HOME:$PATH
export TERM="xterm-256color"
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
	copydir
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

alias ssh_efe="ssh root@167.99.97.126"
alias ssh_sahara="ssh root@165.227.17.151"

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
