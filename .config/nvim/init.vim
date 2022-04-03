" Linux Darwin

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
set list
set listchars=eol:¬,tab:+-
"macbookpro set re=2
set guicursor=

" https://stackoverflow.com/questions/2816719/clear-certain-criteria-from-viminfo-file
" set viminfo='0,:0,<0,@0

" inoremap <C-@> <c-x><c-o>

" move
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" clipboard
"vnoremap <silent> <Leader>y :'<,'>w !xclip -rmlastnl -selection clipboard<CR><CR>

nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

nnoremap <leader>gd gd f' gf
nnoremap <silent><leader>xx :bd<CR>

"https://github.com/junegunn/fzf.vim
"macbookpro set rtp+=/opt/homebrew/opt/fzf
nnoremap <Leader>[ :Buffers<CR>
nnoremap <expr> <C-p> (len(system('git rev-parse')) ? ':Files' : ':GFiles')."\<cr>"
nnoremap <expr> <Leader><Leader> (len(system('git rev-parse')) ? ':Files' : ':GFiles')."\<cr>"
nnoremap <Leader>] :Rg<CR>

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --hidden --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

"https://github.com/mattn/emmet-vim
let g:jsx_ext_require = 0
let g:user_emmet_leader_key='<C-z>'

"https://github.com/prettier/vim-prettier
nmap <Leader>p :PrettierAsync<CR>

"https://github.com/tpope/vim-commentary

"https://github.com/balazs4/ambiance-vim
set termguicolors
syntax on
colorscheme ambiance

"https://github.com/machakann/vim-sandwich

"https://github.com/cormacrelf/vim-colors-github

"https://github.com/neovim/nvim-lspconfig
lua require('lspconfig').tsserver.setup {}
set completeopt=menu,menuone,noselect
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
set signcolumn=yes

"https://github.com/nvim-treesitter/nvim-treesitter
"https://github.com/ojroques/nvim-lspfuzzy
lua require('lspfuzzy').setup {}

"https://github.com/Shatur/neovim-ayu
