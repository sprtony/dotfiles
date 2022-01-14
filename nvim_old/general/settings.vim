" set leader key
let g:mapleader = "\<Space>"

syntax enable
set hidden
set nowrap
set encoding=utf-8
set pumheight=10
set fileencoding=utf-8
set ruler
set cmdheight=2
set iskeyword+=-
set mouse=a
set splitbelow
set splitright
set t_Co=256
set conceallevel=0
set tabstop=4
set shiftwidth=2
set smarttab
set expandtab
set smartindent
set autoindent
set laststatus=0
set number
set cursorline
set background=dark
set showtabline=2
set noshowmode
set nobackup
set nowritebackup
set updatetime=300
set timeoutlen=500
set formatoptions-=cro
set clipboard=unnamedplus
set foldmethod=syntax
set nofoldenable

set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set list
"set autochdir

au! BufWritePost $MYVIMRC source %

autocmd BufNewFile,BufRead *.blade.php set filetype=blade
autocmd BufWritePost *.blade.php call CocAction('format')

" You can't stop me
cmap w!! w !sudo tee %
