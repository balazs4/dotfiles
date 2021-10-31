call plug#begin(stdpath('data') . '/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter'

Plug 'prettier/vim-prettier'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

Plug 'romannmk/ambiance-vim'
Plug 'gruvbox-community/gruvbox'
Plug 'Shatur/neovim-ayu'
call plug#end()

set background=dark
colorscheme ayu-mirage

" colorscheme gruvbox
" let g:gruvbox_guisp_fallback = 'bg'
" let g:gruvbox_contrast_dark = 'hard'

" Plug 'mattn/emmet-vim'
let g:jsx_ext_require = 0
let g:user_emmet_leader_key='<C-z>'

" Plug 'prettier/vim-prettier'
nmap <Leader>p :PrettierAsync<CR>

" Plug 'neovim/nvim-lspconfig'
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
set nobackup
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

