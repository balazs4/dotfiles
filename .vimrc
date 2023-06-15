" Linux Darwin
set termguicolors
syntax on

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
"mcbpro set re=2
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
nnoremap <leader><CR> :write <Bar> silent ! TMUX= source $HOME/.files/.zprofile<CR><C-L>
nnoremap <silent><CR><CR> :lclose <Bar> cclose<CR>
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>
"https://github.com/junegunn/fzf.vim
"mcbpro set rtp+=/opt/homebrew/opt/fzf
nnoremap <Leader>[ :Buffers<CR>
nnoremap <Leader>] :GFiles<CR>
nnoremap <leader><leader> :Commands<CR>
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

"https://github.com/balazs4/zeitgeist
color zeitgeist
