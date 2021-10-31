call plug#begin(stdpath('data') . '/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

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

lua <<EOF
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }
  })
})
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require('lspconfig').tsserver.setup{capabilities = capabilities}
EOF

" Plug 'nvim-telescope/telescope.nvim'
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <leader><leader> <cmd>Telescope live_grep<cr>
nnoremap <leader>/ <cmd>Telescope lsp_definitions<cr>

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

