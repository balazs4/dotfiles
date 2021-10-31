call plug#begin(stdpath('data') . '/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'prettier/vim-prettier'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

Plug 'romannmk/ambiance-vim'
Plug 'arzg/vim-colors-xcode'
call plug#end()

colorscheme xcodedarkhc

" Plug 'mattn/emmet-vim'
let g:jsx_ext_require = 0
let g:user_emmet_leader_key='<C-z>'

" Plug 'prettier/vim-prettier'
nmap <Leader>p :PrettierAsync<CR>

" Plug 'nvim-telescope/telescope.nvim'
lua <<EOF
  require('lspconfig').tsserver.setup{}
EOF

" Plug 'nvim-telescope/telescope.nvim'
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <leader><leader> <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

filetype plugin indent on
set wrap
set noswapfile
set backup
set hidden
set wildmenu
set showcmd
set shiftwidth=2
set expandtab
set autoread
set incsearch
set hlsearch
set ignorecase
set timeoutlen=400 ttimeoutlen=0
set laststatus=2
set title
set number
set rnu
set foldmethod=manual
set completeopt=menu,menuone,noselect

nnoremap <Leader>[ :bp<CR>
nnoremap <Leader>] :bn<CR>

" move
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" clipboard
vnoremap <silent> <Leader>y :'<,'>w !xclip -rmlastnl -selection clipboard<CR><CR>

nnoremap n nzzzv
nnoremap N Nzzzv

