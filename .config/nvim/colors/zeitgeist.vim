" Minimal dark color theme
"
" orig: https://github.com/romannmk/ambiance-vim
" fork: https://github.com/balazs4/zeitgeist
"
" Copyright 2022, All rights reserved
"
" Code licensed under the MIT license
"
" @author Roman Naumenko <https://github.com/romannmk>
" @author Balazs Varga <https://github.com/balazs4>

highlight clear
if exists("syntax_on")
  syntax reset
endif
set background=dark

let g:colors_name = "zeitgeist"

hi clear SignColumn

hi Error             guifg=#ffffff    guibg=#8b0000
hi Boolean           guifg=#ff0087    guibg=#0c0d0e
hi Function          guifg=#ffffff    guibg=#0c0d0e
hi Normal            guifg=#ffffff    guibg=#0c0d0e
hi Pmenu             guifg=#a8a8a8    guibg=#1c1c1c
hi Underlined        guifg=#ffffff    guibg=#0c0d0e
hi MatchParen        guifg=#ff00ff    guibg=#ffffff
hi VertSplit         guifg=#000000    guibg=#0c0d0e
hi WarningMsg        guifg=#000000    guibg=#ff0087
hi String            guifg=#909090    guibg=#0c0d0e
hi Statement         guifg=#bcbcbc    guibg=#0c0d0e
hi CursorLine        guifg=#ffffff    guibg=#1c1c1c
hi Comment           guifg=#4e4e4e    guibg=#0c0d0e
hi Visual            guifg=#ffffff    guibg=#d700d7
hi EndOfBuffer       guifg=#000000    guibg=#0c0d0e
hi NonText           guifg=#000000    guibg=#0c0d0e
hi Search            guifg=#000000    guibg=#79ffe1
hi Special           guifg=#ffffff    guibg=#0c0d0e
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
hi! link PmenuSel MatchParen
hi! link PmenuSbar Pmenu
hi! link PmenuThumb Pmenu
hi! link CursorLineNr CursorLine
hi! link LineNr Comment
hi! link NonText Comment
hi! link CursorLineFold MoreMsg
hi! link Folded MoreMsg
