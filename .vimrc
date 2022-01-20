syntax off
nnoremap <silent> <Leader><CR> :if exists("g:syntax_on") <Bar> syntax off <Bar> else <Bar> syntax on <Bar> endif<CR>
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

" https://stackoverflow.com/questions/2816719/clear-certain-criteria-from-viminfo-file
" set viminfo='0,:0,<0,@0


" move
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" clipboard
"vnoremap <silent> <Leader>y :'<,'>w !xclip -rmlastnl -selection clipboard<CR><CR>

nnoremap n nzzzv
nnoremap N Nzzzv

"goto definitons
nnoremap <leader>gf gd f' gf

"https://github.com/junegunn/fzf.vim
packadd fzf.vim
nnoremap <Leader>[ :Buffers<CR>#
nnoremap <expr> <C-p> (len(system('git rev-parse')) ? ':Files' : ':GFiles')."\<cr>"
nnoremap <expr> <Leader>] (len(system('git rev-parse')) ? ':Files' : ':GFiles')."\<cr>"
nnoremap <Leader><Leader> :Rg<CR>
"vmware nnoremap <Leader>t :Rg <C-r>%<Del><Del><Del>

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
au FileType javascript,typescript,json,html,markdown packadd vim-prettier
au FileType javascript,typescript,json,html,markdown nmap <Leader>p :PrettierAsync<CR>

"https://github.com/tpope/vim-commentary
packadd vim-commentary

"https://github.com/balazs4/ambiance-vim
set termguicolors
syntax on
colorscheme ambiance

"https://github.com/machakann/vim-sandwich
packadd vim-sandwich

"https://github.com/rust-lang/rust.vim
au FileType rust packadd rust.vim
au FileType rust nmap <Leader>p :RustFmt<CR> <bar> :w<CR>

"https://github.com/gruvbox-community/gruvbox
