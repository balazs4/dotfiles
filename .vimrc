syntax off
nnoremap <Leader>] :if exists("g:syntax_on") <Bar> syntax off <Bar> else <Bar> syntax on <Bar> endif<CR>
set t_Co=256
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

" status bar
set laststatus=2
set statusline=%<%F%m%r%h%w\ %=%(%y\ \ %l,%c%V\ %=\ %P%)
hi statusline ctermfg=black ctermbg=white
au InsertLeave * hi statusline ctermfg=black ctermbg=white
au InsertEnter * hi statusline ctermfg=blue ctermbg=white

" https://github.com/junegunn/fzf.vim
nnoremap <C-P> :GFiles<CR>
nnoremap <C-O> :Rg!<CR>

" https://github.com/matze/vim-move
let g:move_key_modifier = 'C'

" https://github.com/mattn/emmet-vim
let g:jsx_ext_require = 0
let g:user_emmet_leader_key='<C-z>'

" https://github.com/prettier/vim-prettier
nmap <Leader>p :PrettierAsync<CR>

