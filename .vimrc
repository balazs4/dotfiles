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
set completeopt=longest,menu,preview,popup
"macbookpro set re=2

" https://stackoverflow.com/questions/2816719/clear-certain-criteria-from-viminfo-file
" set viminfo='0,:0,<0,@0

inoremap <C-@> <c-x><c-o>

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
" nnoremap <leader>gf gd f' gf

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

"https://github.com/rakr/vim-one

"https://github.com/arcticicestudio/nord-vim


"https://github.com/neoclide/coc.nvim --branch release
au FileType typescript packadd coc.nvim
au FileType typescript set signcolumn=number
au FileType typescript set statusline=%F\ %{coc#status()}
au FileType typescript nmap g[ <Plug>(coc-diagnostic-prev)
au FileType typescript nmap g] <Plug>(coc-diagnostic-next)
au FileType typescript nmap gd <Plug>(coc-definition)
au FileType typescript nmap gy <Plug>(coc-type-definition)
au FileType typescript nmap gi <Plug>(coc-implementation)
au FileType typescript nmap gr <Plug>(coc-references)
au FileType typescript nmap gh :call CocActionAsync('doHover')<CR>
au FileType typescript nmap <leader>rr <Plug>(coc-rename)
au FileType typescript nmap <leader>aa <Plug>(coc-codeaction)
au FileType typescript nmap <leader>ff <Plug>(coc-fix-current)
au FileType typescript nmap <leader>oo :<C-u>CocList outline<cr>
au FileType typescript inoremap <silent><expr> <c-@> coc#refresh()
