-- Linux Darwin

vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.guicursor = 'i:block'

-- https://github.com/ibhagwan/fzf-lua
vim.keymap.set('n', '<c-P>', require('fzf-lua').files, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>[', require('fzf-lua').buffers, { noremap = true, silent = true })
vim.keymap.set('n', '<leader><leader>', require('fzf-lua').builtin, { noremap = true, silent = true })

-- https://github.com/neovim/nvim-lspconfig
vim.diagnostic.config({virtual_text = false, signs = false})
require('lspconfig')['gopls'].setup({
	on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', 'gR', vim.lsp.buf.rename, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', '<leader>p', vim.lsp.buf.formatting, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', 'ga', require('fzf-lua').lsp_code_actions, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', 'gb', require('fzf-lua').lsp_document_diagnostics, {noremap=true, silent=true, buffer=bufnr})
	end
})

require('lspconfig')['tsserver'].setup({
	on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', 'gR', vim.lsp.buf.rename, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', 'ga', require('fzf-lua').lsp_code_actions, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', 'gb', require('fzf-lua').lsp_document_diagnostics, {noremap=true, silent=true, buffer=bufnr})
	end
})
-- https://github.com/Shatur/neovim-ayu
vim.cmd 'colorscheme ayu-mirage'

-- https://github.com/prettier/vim-prettier
vim.keymap.set('n', '<leader>p', ':PrettierAsync<CR>', { noremap = true, silent = true })

-- https://github.com/nvim-treesitter/nvim-treesitter

