if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
export _JAVA_AWT_WM_NONREPARENTING=1
export EDITOR="nvim"
# export TERM="xterm-kitty"
export CHROME_EXECUTABLE=google-chrome-stable

#Mis Variables
export ComposerPath=$HOME/.config/composer/vendor/bin
export CURLPath=/usr/local/opt/curl/bin
export ANDROID_HOME=$HOME/Android/Sdk
export FLUTTER_HOME=/opt/flutter/bin
export PATH=$HOME/.local/bin:$HOME/bin:/usr/local/bin:$CURLPath:$ComposerPath:$FLUTTER_HOME:$PATH


export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'

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

# Example aliases
alias ls="lsd"
alias cat="bat"
alias git_efe_push="git ftp push -u root --key ~/.ssh/id_rsa sftp://calzadoefe.com/var/www/efe"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/quimaira/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/quimaira/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/quimaira/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/quimaira/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

