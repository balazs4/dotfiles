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
" set list
" set listchars=tab:\ \ ,trail:·,eol:¬,nbsp:_
set guicursor=
"macbookpro set re=2
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
nnoremap <leader><CR> :write <Bar> silent ! TMUX= source $HOME/.files/.zprofile<CR><C-L>
nnoremap <silent><CR><CR> :lclose <Bar> cclose<CR>

"https://github.com/junegunn/fzf.vim
"macbookpro set rtp+=/opt/homebrew/opt/fzf
nnoremap <Leader>[ :Buffers<CR>
nnoremap <expr> <C-p> (len(system('git rev-parse')) ? ':Files' : ':GFiles')."\<cr>"
nnoremap <Leader>] :Rg<CR>
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

"https://github.com/natebosch/vim-lsc
nnoremap gb :LSClientWindowDiagnostics<CR>
set omnifunc=lsc#complete#complete
set completeopt=menu,menuone,noinsert,noselect
let g:lsc_auto_map = {'defaults': v:true, 'PreviousReference': ''}
let g:lsc_reference_highlights = v:false
let g:lsc_trace_level = 'off'
let g:lsc_diagnostic_highlights = v:false
let g:lsc_autocomplete_length = 2
"macbookpro let g:lsc_server_commands = {
"macbookpro       \ 'go':               { 'command': 'gopls serve',                        'log_level': -1, 'suppress_stderr': v:true }
"macbookpro       \ ,'javascript':      { 'command': 'typescript-language-server --stdio', 'log_level': -1, 'suppress_stderr': v:true }
"macbookpro       \ ,'typescript':      { 'command': 'typescript-language-server --stdio', 'log_level': -1, 'suppress_stderr': v:true }
"macbookpro       \ ,'javascriptreact': { 'command': 'typescript-language-server --stdio', 'log_level': -1, 'suppress_stderr': v:true }
"macbookpro       \ ,'typescriptreact': { 'command': 'typescript-language-server --stdio', 'log_level': -1, 'suppress_stderr': v:true }
"macbookpro       \ }
"carbon let g:lsc_server_commands = {
"carbon       \ 'go':               { 'command': 'gopls serve',                        'log_level': -1, 'suppress_stderr': v:true }
"carbon       \ }

"macbookpro "https://github.com/leafgarland/typescript-vim

"macbookpro "https://github.com/jelera/vim-javascript-syntax

"https://github.com/ayu-theme/ayu-vim

"https://github.com/balazs4/ambiance-vim
"carbon color ambiance

"https://github.com/darrikonn/vim-gofmt
nmap <Leader>f :GoImports<CR> <Bar> :GoFmt<CR> <Bar> :write<CR>

"https://github.com/dracula/vim
let g:dracula_underline = 0
let g:dracula_italic = 0
"macbookpro color dracula

"https://github.com/sonph/onehalf
set rtp+=~/.vim/pack/_/start/onehalf/vim/

