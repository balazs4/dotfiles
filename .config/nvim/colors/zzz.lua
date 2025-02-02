-- base00-hex: ----
-- base01-hex: ---
-- base02-hex: --
-- base03-hex: -
-- base04-hex: +
-- base05-hex: ++
-- base06-hex: +++
-- base07-hex: ++++
-- base08-hex: red
-- base09-hex: orange
-- base0A-hex: yellow
-- base0B-hex: green
-- base0C-hex: aqua
-- base0D-hex: blue
-- base0E-hex: purple
-- base0F-hex: brown
-- variant: light|dark

vim.g.colors_name = 'zzz'
vim.cmd('runtime colors/default.vim')
vim.opt.background = '{{variant}}'

vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NonText', { bg = 'none' })
vim.api.nvim_set_hl(0, 'MatchParen', { fg = '#{{base09-hex}}' })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#{{base01-hex}}' })
vim.api.nvim_set_hl(0, 'Statement', { fg = '#{{base07-hex}}', bold = true })
vim.api.nvim_set_hl(0, 'Keyword', { fg = '#{{base05-hex}}', bold = true })
vim.api.nvim_set_hl(0, 'QuickFixLine', { bg = '#{{base09-hex}}', fg = '#{{base07-hex}}', bold = false })
