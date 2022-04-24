" Linux Darwin
syntax off
nnoremap <silent> <Leader><CR> :if exists("g:syntax_on") <Bar> syntax off <Bar> else <Bar> syntax on <Bar> endif<CR>
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
set complete+=kspell
set list
set listchars=eol:¬,tab:+-
"macbookpro set re=2

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
nnoremap <CR><CR> :silent ! source $HOME/.files/.zprofile<CR><C-L>

"https://github.com/junegunn/fzf.vim
"macbookpro set rtp+=/opt/homebrew/opt/fzf
packadd fzf.vim
nnoremap <Leader>[ :Buffers<CR>
nnoremap <expr> <C-p> (len(system('git rev-parse')) ? ':Files' : ':GFiles')."\<cr>"
nnoremap <expr> <Leader><Leader> (len(system('git rev-parse')) ? ':Files' : ':GFiles')."\<cr>"
nnoremap <Leader>] :Rg<CR>

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --hidden --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

"https://github.com/mattn/emmet-vim
au FileType javascript,typescriptreact,javascriptreact,html packadd emmet-vim
let g:jsx_ext_require = 0
let g:user_emmet_leader_key='<C-z>'

"https://github.com/prettier/vim-prettier
au FileType javascript,typescript,javascriptreact,typescriptreact,json,html,markdown packadd vim-prettier
au FileType javascript,typescript,javascriptreact,typescriptreact,json,html,markdown nmap <Leader>p :PrettierAsync<CR>

"https://github.com/tpope/vim-commentary
packadd vim-commentary

"https://github.com/balazs4/ambiance-vim
set termguicolors
syntax on
colorscheme ambiance

"https://github.com/machakann/vim-sandwich
packadd vim-sandwich

"https://github.com/rakr/vim-one

"https://github.com/arcticicestudio/nord-vim

"https://github.com/cormacrelf/vim-colors-github

"https://github.com/Quramy/tsuquyomi
packadd tsuquyomi
au FileType typescript,javascriptreact setlocal completeopt+=menu,preview
" let g:tsuquyomi_completion_detail = 1
let g:tsuquyomi_ignore_missing_modules = 1
let g:tsuquyomi_definition_split = 2 "0:edit 1:split 2:vsplit 3:tabedit
let g:tsuquyomi_disable_quickfix = 1
au FileType typescript,javascriptreact nmap <Leader>t :TsuAsyncGeterr<CR>
