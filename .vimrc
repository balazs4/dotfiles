syntax off
nnoremap <silent> <Leader>] :if exists("g:syntax_on") <Bar> syntax off <Bar> else <Bar> syntax on <Bar> endif<CR>
filetype plugin indent on
set nowrap
set noswapfile
set wildmenu
set showcmd
set shiftwidth=2
set expandtab
set autoread
set incsearch
set hlsearch
set ignorecase
set timeoutlen=400 ttimeoutlen=0

nnoremap <Leader>l :Buffers<CR>
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>

"status bar
set laststatus=2
set statusline=[%2n]\ %<%F%m%r%h%w\ %=%(%y\ \ %l,%c%V\ %=\ %P%)
                 hi statusline ctermfg=white ctermbg=black cterm=bold 
au InsertLeave * hi statusline ctermfg=white ctermbg=black cterm=bold 
au InsertEnter * hi statusline ctermfg=white ctermbg=blue cterm=bold 

"https://github.com/junegunn/fzf.vim
nnoremap <C-P> :GFiles<CR>
nnoremap <C-O> :Rg!<CR>

"https://github.com/matze/vim-move
let g:move_key_modifier = 'C'

"https://github.com/mattn/emmet-vim
let g:jsx_ext_require = 0
let g:user_emmet_leader_key='<C-z>'

"https://github.com/prettier/vim-prettier
nmap <Leader>p :PrettierAsync<CR>

"https://github.com/tpope/vim-commentary

"https://github.com/fxn/vim-monochrome

"https://github.com/tpope/vim-surround

"https://github.com/ayu-theme/ayu-vim
" set termguicolors
" colorscheme ayu
" syntax on
" let ayucolor="dark"
"light let ayucolor="light"
