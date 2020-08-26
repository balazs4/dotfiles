set nocompatible
set ignorecase
syntax enable
colorscheme industry
filetype plugin indent on

set path=$PWD/**
set noshowmode
set wildmenu
set laststatus=2
set showcmd
set t_Co=256
set noswapfile
set nowrap
set backupcopy=yes
set timeoutlen=400 ttimeoutlen=0
set number
set relativenumber
set shiftwidth=2
set expandtab
set splitbelow
set splitright
set incsearch
set hlsearch
set autoread

set nocul
autocmd InsertEnter,InsertLeave * set cul!
autocmd BufNewFile,BufReadPost .babelrc set filetype=json
autocmd BufNewFile,BufReadPost vifmrc set filetype=vim
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

cnoremap Q q
cnoremap W w
cnoremap X x

" PLUGINS
call plug#begin('~/.vim/plugged')

  Plug 'mattn/emmet-vim'
  let g:jsx_ext_required = 0
  let g:user_emmet_leader_key='<C-Z>'

  Plug 'tpope/vim-surround'

  Plug 'airblade/vim-gitgutter', { 'commit': '67d5dc11d6ab8199397481aa89672a57340106d6', 'frozen': 'true'}
  set signcolumn=yes

  Plug 'prettier/vim-prettier', { 'branch': 'issue/232-adding-support-for-prettier-2.x'} 
  autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,.fxrc Prettier

  Plug 'itchyny/lightline.vim'
  let g:lightline = { 'colorscheme' : 'powerline' }

  Plug '/usr/bin/fzf'
  Plug 'junegunn/fzf.vim'
  nnoremap <C-P> :Files<CR>

  Plug 'matze/vim-move'
  let g:move_key_modifier = 'C'

  Plug 'tpope/vim-commentary'

  Plug 'fxn/vim-monochrome'
  Plug 'cormacrelf/vim-colors-github'
  Plug 'pgdouyon/vim-yin-yang'

call plug#end()

  " mode: dark
  colorscheme monochrome
  let g:lightline = { 'colorscheme' : 'powerline' }
  
