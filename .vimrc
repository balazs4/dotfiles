set termguicolors
syntax on
colorscheme quiet
set background={{variant}}
hi Normal guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE

filetype plugin indent on
set wrap
set noswapfile
set nobackup
set hidden
set nowritebackup
set wildmenu
set showcmd
set shiftwidth=2
set expandtab
set tabstop=2
set softtabstop=2
set autoread
set incsearch
set hlsearch
set ignorecase
set encoding=utf-8
set nowritebackup
set updatetime=300
set timeoutlen=400 ttimeoutlen=0
set laststatus=2
set title
set number
set rnu
set foldmethod=manual
set shortmess+=c
set complete+=kspell
set list
set listchars=tab:\ \ ,trail:·,eol:\ ,nbsp:_
set guicursor=
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

