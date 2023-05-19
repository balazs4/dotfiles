-- Linux Darwin

vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.guicursor = 'i:block'
vim.opt.termguicolors = true
vim.opt.completeopt = 'menu'
vim.opt.cursorline = false
vim.opt.nu = true
vim.opt.rnu = false
vim.opt.list = true
vim.opt.listchars = "tab:  ,trail:·,eol: ,nbsp:_"
vim.opt.cmdheight = 1

vim.keymap.set('n', '<leader>g', function()
  local filename = string.gsub(vim.fn.expand('%'), os.getenv('PWD') or "", "")
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.cmd('! gh browse ' .. filename .. ':' .. row)
end, { noremap = true, silent = true })

-- https://github.com/ibhagwan/fzf-lua
require('fzf-lua').setup { winopts = { fullscreen = false, preview = { layout = 'vertical' } } }
vim.keymap.set('n', '<leader>]', require('fzf-lua').files, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>[', require('fzf-lua').buffers, { noremap = true, silent = true })
vim.keymap.set('n', '<leader><leader>', require('fzf-lua').builtin, { noremap = true, silent = true })
vim.keymap.set('n', '``', require('fzf-lua').resume, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>=', require('fzf-lua').blines, { noremap = true, silent = true })

-- https://github.com/hrsh7th/cmp-nvim-lsp
-- https://github.com/hrsh7th/cmp-buffer
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
  sources = require('cmp').config.sources({ { name = 'nvim_lsp' } })
})

-- https://github.com/neovim/nvim-lspconfig
vim.diagnostic.config({ virtual_text = true, signs = false, update_in_insert = false })

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local function on_attach(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, { noremap = true, silent = true, buffer = bufnr })
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true, buffer = bufnr })
  vim.keymap.set('n', 'gR', vim.lsp.buf.rename, { noremap = true, silent = true, buffer = bufnr })
  vim.keymap.set('n', '<leader>p', function() vim.lsp.buf.format { async = true } end,
    { noremap = true, silent = true, buffer = bufnr })
  vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, { noremap = true, silent = true, buffer = bufnr })
  vim.keymap.set('n', 'ga', require('fzf-lua').lsp_code_actions, { noremap = true, silent = true, buffer = bufnr })
  vim.keymap.set('n', '<leader>b', require('fzf-lua').lsp_document_diagnostics, { noremap = true, silent = true })
  vim.keymap.set('n', '<leader>y', require('fzf-lua').lsp_document_symbols, { noremap = true, silent = true })
  vim.keymap.set('n', '<leader>T', vim.diagnostic.open_float, { noremap = true, silent = true })
end

require('lspconfig')['rust_analyzer'].setup({ capabilities = capabilities, on_attach = on_attach })
require('lspconfig')['gopls'].setup({ capabilities = capabilities, on_attach = on_attach })

require('lspconfig')['tsserver'].setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    vim.keymap.del('n', '<leader>p', { buffer = bufnr })
    -- https://github.com/prettier/vim-prettier
    vim.keymap.set('n', '<leader>p', ':PrettierAsync<CR>', { noremap = true, silent = true })

    vim.keymap.set('n', '<leader>t', function()
      local filename = vim.fn.expand('%')
      local testfilename = string.gsub(filename, ".ts$", ".test.ts")
      vim.cmd('vsplit ' .. testfilename)
    end, { noremap = true, silent = true })

    vim.keymap.set('n', '<leader>r', function()
      local function split(inputstr, sep)
        if sep == nil then
          sep = "%s"
        end
        local t = {}
        for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
          table.insert(t, str)
        end
        return t
      end

      local filename = vim.fn.expand('%')
      local testfilename = filename:sub(-string.len('test.ts')) == 'test.ts'
          and filename
          or string.gsub(filename, ".ts$", ".test.ts")

      vim.cmd('! tmux split-window jest --watch ' .. testfilename)
      vim.cmd('! tmux select-pane -l')
      vim.cmd('! tmux send-keys Enter')
    end, { noremap = true, silent = true })
  end
})

require('lspconfig')['lua_ls'].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      telemetry = { enable = false, },
      runtime = { version = 'LuaJIT', },
      diagnostics = { globals = { 'vim', 'ngx', 'describe', 'it' }, },
      workspace = { checkThirdParty = false }
    }
  }
})

-- https://github.com/terrortylor/nvim-comment
require('nvim_comment').setup()

-- https://github.com/catppuccin/nvim catppuccin

-- https://github.com/balazs4/zeitgeist
vim.cmd("colorscheme zeitgeist")

-- https://github.com/navarasu/onedark.nvim

-- https://github.com/phaazon/hop.nvim
require('hop').setup { keys = 'etovxqpdygfblzhckisuran' }
