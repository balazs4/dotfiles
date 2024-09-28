vim.g.colors_name = 'zzz'
vim.cmd('runtime colors/quiet.vim')

vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NonText', { bg = 'none' })
