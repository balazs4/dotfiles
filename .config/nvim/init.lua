-- Linux Darwin

vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.guicursor = 'i:block'

-- https://github.com/Shatur/neovim-ayu
require('ayu').colorscheme()

-- https://github.com/ibhagwan/fzf-lua
vim.keymap.set('n', '<c-P>', require('fzf-lua').files, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>[', require('fzf-lua').buffers, { noremap = true, silent = true })

-- https://github.com/neovim/nvim-lspconfig
require('lspconfig')['gopls'].setup({
	on_attach = function(client, bufnr)
    vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, {noremap=true, silent=true, buffer=bufnr})
	end
})

