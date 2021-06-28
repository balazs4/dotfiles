syntax off
nnoremap <silent> <Leader>] :if exists("g:syntax_on") <Bar> syntax off <Bar> else <Bar> syntax on <Bar> endif<CR>
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

nnoremap <Leader>f :bp<CR>
nnoremap <Leader>j :bn<CR>
nnoremap <Leader><Leader> :bn<CR>

" move
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" clipboard
vnoremap <silent> <Leader>y :'<,'>w !xclip -rmlastnl -selection clipboard<CR><CR>

iabbrev jsonstr JSON.stringify()
iabbrev inspect console.log(JSON.stringify({},null,2));

"https://github.com/junegunn/fzf.vim
packadd fzf.vim
nnoremap <Leader>l :Buffers<CR>
nnoremap <C-p> :GFiles<CR>
nnoremap <Leader>[ :Rg<CR>

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --hidden --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

"https://github.com/mattn/emmet-vim
au FileType javascript packadd emmet-vim
au FileType html packadd emmet-vim
let g:jsx_ext_require = 0
let g:user_emmet_leader_key='<C-z>'

"https://github.com/prettier/vim-prettier
nmap <Leader>p :packadd vim-prettier <bar> :PrettierAsync<CR>

"https://github.com/tpope/vim-commentary
packadd vim-commentary

"https://github.com/tpope/vim-surround
packadd vim-surround

"https://github.com/fxn/vim-monochrome
set termguicolors
syntax on
colorscheme monochrome

"https://github.com/ayu-theme/ayu-vim
" set termguicolors
" syntax on
" let ayucolor="dark"
"light let ayucolor="light"
" colorscheme ayu
