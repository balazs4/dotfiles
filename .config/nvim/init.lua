-- Linux Darwin

vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.guicursor = 'i:block'
vim.opt.termguicolors = true
vim.opt.completeopt = 'menu'
vim.opt.cursorline = true

-- https://github.com/ibhagwan/fzf-lua
require('fzf-lua').setup{
  winopts = {
    fullscreen = true
  }
}
vim.keymap.set('n', '<c-P>', require('fzf-lua').files, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>[', require('fzf-lua').buffers, { noremap = true, silent = true })
vim.keymap.set('n', '<leader><leader>', require('fzf-lua').builtin, { noremap = true, silent = true })
vim.keymap.set('n', '``', require('fzf-lua').resume, { noremap = true, silent = true })

-- https://github.com/hrsh7th/cmp-nvim-lsp
-- https://github.com/hrsh7th/cmp-buffer
-- https://github.com/hrsh7th/cmp-path
-- https://github.com/hrsh7th/nvim-cmp
-- https://github.com/hrsh7th/cmp-vsnip
-- https://github.com/hrsh7th/vim-vsnip
require('cmp').setup({
  snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end, },
  mapping = require('cmp').mapping.preset.insert({
    ['<C-b>'] = require('cmp').mapping.scroll_docs(-4),
    ['<C-f>'] = require('cmp').mapping.scroll_docs(4),
    ['<C-Space>'] = require('cmp').mapping.complete(),
    ['<C-e>'] = require('cmp').mapping.abort(),
    ['<CR>'] = require('cmp').mapping.confirm({ select = true }),
  }),
  sources = require('cmp').config.sources({ { name = 'nvim_lsp' }, { name = 'vsnip' }, }, { { name = 'buffer' }, })
})

-- https://github.com/neovim/nvim-lspconfig
vim.diagnostic.config({virtual_text = true, signs = false, update_in_insert = false})

require('lspconfig')['rust_analyzer'].setup({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', 'gR', vim.lsp.buf.rename, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', '<leader>p', function() vim.lsp.buf.format { async = true} end, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', 'ga', require('fzf-lua').lsp_code_actions, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', 'gb', require('fzf-lua').lsp_document_diagnostics, {noremap=true, silent=true, buffer=bufnr})
	end
})

require('lspconfig')['tsserver'].setup({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', 'gR', vim.lsp.buf.rename, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', '<leader>p', function() vim.lsp.buf.format { async = true} end, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', 'ga', require('fzf-lua').lsp_code_actions, {noremap=true, silent=true, buffer=bufnr})
    vim.keymap.set('n', 'gb', require('fzf-lua').lsp_document_diagnostics, {noremap=true, silent=true, buffer=bufnr})
	end
})

-- https://github.com/Shatur/neovim-ayu
vim.cmd 'colorscheme ayu-mirage'

-- https://github.com/prettier/vim-prettier
vim.keymap.set('n', '<leader>p', ':PrettierAsync<CR>', { noremap = true, silent = true })

-- https://github.com/andreasvc/vim-256noir

-- https://github.com/balazs4/ambiance-vim

-- https://github.com/terrortylor/nvim-comment
require('nvim_comment').setup()
