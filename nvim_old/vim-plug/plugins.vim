call plug#begin('~/.config/nvim/autoload/plugged')

	" Better Syntax Support
	Plug 'sheerun/vim-polyglot'
	" File Explorer
	" Plug 'scrooloose/NERDTree'
	" Auto pairs for '(' '[' '{'
	Plug 'jiangmiao/auto-pairs'
  " Onedark theme
  Plug 'joshdick/onedark.vim'
  " Stable version of coc
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " Status line
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'preservim/tagbar' 
  " comentar bloques
  "Plug 'preservim/nerdcommenter'
  Plug 'tpope/vim-commentary'
  " ragner support
  Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}
  "Colorized
  Plug 'norcalli/nvim-colorizer.lua'
  "parentesis color
  Plug 'junegunn/rainbow_parentheses.vim'
  "FZF
  " Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  " Plug 'junegunn/fzf.vim'
  Plug 'airblade/vim-rooter'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

  " Startify
  Plug 'mhinz/vim-startify'  
  " Git
  Plug 'mhinz/vim-signify'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
  Plug 'junegunn/gv.vim'
  " Emmet
  Plug 'mattn/emmet-vim'
  " Laravel
  Plug 'phpactor/phpactor', {'for': 'php', 'branch': 'master', 'do': 'composer install --no-dev -o'}
  Plug 'tpope/vim-dispatch'             "| Optional
  Plug 'tpope/vim-projectionist'        "|
  Plug 'noahfrederick/vim-composer'     "|
  Plug 'noahfrederick/vim-laravel'
  " sneak
  Plug 'justinmk/vim-sneak'
  "  Whitch key
  Plug 'liuchengxu/vim-which-key'
  "Quick Scope
  Plug 'unblevable/quick-scope'
  " Float Term
  Plug 'voldikss/vim-floaterm'
  " TabNine
  Plug 'codota/tabnine-vim'
  "Ranger
  Plug 'Lokaltog/neoranger'
call plug#end()
