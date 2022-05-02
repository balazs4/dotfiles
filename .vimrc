" Linux Darwin
" colors based on nucl1d3/ambiance-vim
set termguicolors
syntax on
highlight clear
set background=dark
hi clear SignColumn
hi Error             guifg=#ff0087    guibg=#000000
hi Function          guifg=#ffffff    guibg=#000000
hi Normal            guifg=#ffffff    guibg=#000000
hi Pmenu             guifg=#a8a8a8    guibg=#1c1c1c
hi Underlined        guifg=#ffffff    guibg=#000000
hi MatchParen        guifg=#ff00ff    guibg=#ffffff
hi VertSplit         guifg=#000000    guibg=#000000
hi WarningMsg        guifg=#000000    guibg=#ff0087
hi String            guifg=#909090    guibg=#000000
hi Statement         guifg=#bcbcbc    guibg=#000000
hi CursorLine        guifg=#ffffff    guibg=#1c1c1c
hi Comment           guifg=#4e4e4e    guibg=#000000
hi Visual            guifg=#ffffff    guibg=#d700d7
hi EndOfBuffer       guifg=#000000    guibg=#000000
hi NonText           guifg=#000000    guibg=#000000
hi Search            guifg=#000000    guibg=#79ffe1
hi Special           guifg=#ffffff    guibg=#000000
hi! link StorageClass Function
hi! link xmlTag Normal
hi! link xmlTagName Normal
hi! link xmlEndTag Normal
hi! link htmlTag Normal
hi! link htmlTagName Normal
hi! link htmlEndTag Normal
hi! link Directory Normal
hi! link Constant Normal
hi! link Type Normal
hi! link jsObjectKey Normal
hi! link jsThis Normal
hi! link Conditional Normal
hi! link PreProc Normal
hi! link Title Normal
hi! link Ignore String
hi! link StatusLine String
hi! link StatusLineNC String
hi! link TabLine String
hi! link TabLineFill String
hi! link WildMenu String
hi! link Number String
hi! link Float String
hi! link TabLineSel String
hi! link Todo String
hi! link SpecialKey String
hi! link Structure String
hi! link Identifier String
hi! link TypeDef String
hi! link MoreMsg String
hi! link Directory String
hi! link DiffText String
hi! link TabLineSel String
hi! link Boolean Error
hi! link PmenuSel MatchParen
hi! link PmenuSbar Pmenu
hi! link PmenuThumb Pmenu
hi! link CursorLineNr CursorLine
hi! link LineNr Comment
hi! link NonText Comment
hi! link CursorLineFold MoreMsg
hi! link Folded MoreMsg

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
set listchars=eol:¬,tab:..
set guicursor=
"macbookpro set re=2
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
nnoremap <leader>gd gd f' gf
nnoremap <silent><leader>xx :bd<CR>
nnoremap <CR><CR> :write <Bar> silent ! TMUX= source $HOME/.files/.zprofile<CR><C-L>
nnoremap <leader><CR> :source $MYVIMRC<CR>
nnoremap <leader><leader> :Commands<CR>

"https://github.com/junegunn/fzf.vim
"macbookpro set rtp+=/opt/homebrew/opt/fzf
nnoremap <Leader>[ :Buffers<CR>
nnoremap <expr> <C-p> (len(system('git rev-parse')) ? ':Files' : ':GFiles')."\<cr>"
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

"https://github.com/machakann/vim-sandwich

"https://github.com/prabirshrestha/async.vim

"https://github.com/prabirshrestha/vim-lsp
let g:lsp_use_lua = 1

au User lsp_setup call lsp#register_server({
      \ 'name': 'typescript-language-server',
      \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
      \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
      \ 'whitelist': ['typescript', 'typescript.tsx', 'typescriptreact', 'javascript.jsx', 'javascript', 'javascriptreact'],
      \ })

nnoremap <c-\> :LspReferences<cr>
nnoremap <c-]> :LspDefinition<cr>
nnoremap T :LspDocumentDiagnostics<cr>
nnoremap K :LspPeekDefinition<cr>
nnoremap H :LspHover<cr>
nnoremap F :LspCodeAction<cr>
set omnifunc=lsp#complete
set signcolumn=yes

let g:lsp_diagnostics_echo_cursor = 1 "status line
let g:lsp_diagnostics_echo_delay = 50
let g:lsp_diagnostics_highlights_enabled = 0
let g:lsp_diagnostics_highlights_insert_mode_enabled = 0
let g:lsp_diagnostics_signs_insert_mode_enabled = 1
let g:lsp_document_code_action_signs_enabled = 0 "A>
let g:lsp_document_highlight_enabled = 0
let g:lsp_diagnostics_signs_enabled = 0

