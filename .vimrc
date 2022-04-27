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
nnoremap <CR><CR> :write <Bar> silent ! TMUX= source $HOME/.files/.zprofile<CR><C-L>
nnoremap <Space><Space> :Commands<CR>

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
#carbon packadd vim-commentary

"https://github.com/balazs4/ambiance-vim
set termguicolors
syntax on
colorscheme ambiance

"https://github.com/machakann/vim-sandwich
#carbon packadd vim-sandwich

"https://github.com/arcticicestudio/nord-vim

"https://github.com/cormacrelf/vim-colors-github
"
"https://github.com/rakr/vim-one

"https://github.com/ayu-theme/ayu-vim

"https://github.com/prabirshrestha/vim-lsp
#carbon packadd vim-lsp
let g:lsp_use_lua = has('nvim-0.4.0') || (has('lua') && has('patch-8.2.0775'))

au User lsp_setup call lsp#register_server({
      \ 'name': 'typescript-language-server',
      \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
      \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
      \ 'whitelist': ['typescript', 'typescript.tsx', 'typescriptreact'],
      \ })

autocmd FileType typescript nnoremap <buffer><silent> <leader>t :cclose <bar> lclose <bar> LspDocumentDiagnostics<cr>
autocmd FileType typescript nnoremap <buffer><silent> T :cclose <bar> lclose <bar>LspReferences<cr>
autocmd FileType typescript nnoremap <buffer><silent> <c-]> :LspDefinition<cr>
autocmd FileType typescript nnoremap <buffer><silent> K :LspPeekDefinition<cr>
autocmd FileType typescript nnoremap <buffer><silent> H :LspHover<cr>
autocmd FileType typescript nnoremap <buffer><silent> A :LspCodeAction<cr>
autocmd FileType typescript setlocal omnifunc=lsp#complete
autocmd FileType typescript setlocal signcolumn=yes

let g:lsp_diagnostics_echo_cursor = 1 "status line
let g:lsp_diagnostics_echo_delay = 50
let g:lsp_diagnostics_highlights_enabled = 0
let g:lsp_diagnostics_highlights_insert_mode_enabled = 0
let g:lsp_diagnostics_signs_insert_mode_enabled = 0
let g:lsp_document_code_action_signs_enabled = 0 "A>
let g:lsp_document_highlight_enabled = 0

"https://github.com/prabirshrestha/async.vim
#carbon packadd async.vim
