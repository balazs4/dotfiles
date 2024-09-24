-- inpsired by https://github.com/rezhaTanuharja/minimalistNVIM

vim.api.nvim_command('syntax reset')
vim.g.colors_name = 'zzz'

vim.api.nvim_set_hl(0, 'Normal', { fg = '#cccccc', bg = 'none'})
vim.api.nvim_set_hl(0, 'NonText', { bg = 'none'})
vim.api.nvim_set_hl(0, 'Search', { fg = '#000000', bg = '#FFFFFF' })
vim.api.nvim_set_hl(0, 'CurSearch', { fg = '#000000', bg = '#FFFFFF' })
vim.api.nvim_set_hl(0, 'Comment', { fg = '#555555', italic = false })
vim.api.nvim_set_hl(0, 'String', { fg = '#bbbbbb', italic = false })
vim.api.nvim_set_hl(0, 'Function', { fg = '#999999', italic = false })
vim.api.nvim_set_hl(0, 'Identifier', { fg = '#999999', italic = false })
vim.api.nvim_set_hl(0, 'Special', { fg = '#777777', italic = false })
vim.api.nvim_set_hl(0, 'Question', { fg = '#666666', italic = false })
vim.api.nvim_set_hl(0, 'Directory', { fg = '#777777', italic = false })
vim.api.nvim_set_hl(0, 'Directory', { fg = '#777777', italic = false })
vim.api.nvim_set_hl(0, 'NvimTreeFolderIcon', { fg = '#777777', italic = false })
