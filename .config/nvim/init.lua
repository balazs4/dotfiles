-- Linux Darwin

vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- https://github.com/Shatur/neovim-ayu
require('ayu').colorscheme()

-- https://github.com/neovim/nvim-lspconfig
require('lspconfig')['gopls'].setup({
	on_attach = function(client, bufnr)
    vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, {noremap=true, silent=true, buffer=bufnr})
	end
})


-- https://github.com/ibhagwan/fzf-lua
