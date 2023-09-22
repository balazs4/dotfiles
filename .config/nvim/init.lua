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
vim.cmd('let g:loaded_matchparen=1')

vim.keymap.set('n', '<leader>g', function()
  local filename = string.gsub(vim.fn.expand('%'), os.getenv('PWD') or "", "")
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.cmd('! gh browse ' .. filename .. ':' .. row)
end, { noremap = true, silent = true })

vim.diagnostic.config({ virtual_text = true, signs = false, update_in_insert = false })

vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, { noremap = true, silent = true})
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true})
vim.keymap.set('n', 'gR', vim.lsp.buf.rename, { noremap = true, silent = true})
vim.keymap.set('n', '<leader>p', function() vim.lsp.buf.format { async = true } end, { noremap = true, silent = true)
vim.keymap.set('n', '<leader>T', vim.diagnostic.open_float, { noremap = true, silent = true })

-- prettier
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'html', 'md'},
  callback = function()
    vim.keymap.del('n', '<leader>p', { buffer = 0 })
    vim.keymap.set('n', '<leader>p', function()
      vim.cmd(':w %')
      local filename = vim.fn.expand('%')
      vim.cmd('! bun x prettier --write ' .. filename)
      vim.cmd(':e %')
    end, { noremap = true, silent = true })
  end
})

-- LSP: go
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'go'},
  callback = function()
    vim.lsp.buf_attach_client(
      0,
      vim.lsp.start({
          name = 'gopls',
          cmd = {'gopls'},
          root_dir = vim.fs.dirname( vim.fs.find({'go.mod'}, { upward = true })[1])
      })
    )
  end
})

-- LSP: typescript
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'typescript', 'typescriptreact'},
  callback = function()
    vim.lsp.buf_attach_client(
      0,
      vim.lsp.start({
          name = 'typescript-language-server',
          cmd = {'typescript-language-server', '--stdio'},
          root_dir = vim.fs.dirname( vim.fs.find({'tsconfig.json'}, { upward = true })[1])
      })
    )

    vim.keymap.set('n', '<leader>t', function()
      local filename = vim.fn.expand('%')
      local targetfilename = filename:sub(-string.len('test.ts')) == 'test.ts'
          and string.gsub(filename, ".test.ts$", ".ts")
          or string.gsub(filename, ".ts$", ".test.ts")

      vim.cmd('vsplit ' .. targetfilename)
    end, { noremap = true, silent = true })

    vim.keymap.set('n', '<leader>r', function()
      local filename = vim.fn.expand('%')
      local workspace = {}
      for p in string.gmatch(filename, "([^/]+)") do table.insert(workspace, p) end

      local testfilename = filename:sub(-string.len('test.ts')) == 'test.ts'
          and filename
          or string.gsub(filename, ".ts$", ".test.ts")

      vim.cmd('! tmux split-window pnpm --filter ' .. workspace[2] .. ' test -- --watch ' .. testfilename)
      vim.cmd('! tmux select-pane -l')
      vim.cmd('! tmux send-keys Enter')
    end, { noremap = true, silent = true })
  end
})



-- https://github.com/ibhagwan/fzf-lua
require('fzf-lua').setup { 'default', winopts = { fullscreen = true, preview = { layout = 'vertical' } } }
vim.keymap.set('n', '<leader>=', require('fzf-lua').builtin, { noremap = true, silent = true })
vim.keymap.set('n', '<leader><leader>', require('fzf-lua').files, { noremap = true, silent = true })
vim.keymap.set('n', '``', require('fzf-lua').buffers, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>-', require('fzf-lua').grep_project, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>w', require('fzf-lua').grep_cword, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>W', require('fzf-lua').grep_cWORD, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>/', require('fzf-lua').blines, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>`', require('fzf-lua').git_status, { noremap = true, silent = true })

vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, { noremap = true, silent = true})
vim.keymap.set('n', 'ga', require('fzf-lua').lsp_code_actions, { noremap = true, silent = true})
vim.keymap.set('n', '<leader>b', require('fzf-lua').lsp_document_diagnostics, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>y', require('fzf-lua').lsp_document_symbols, { noremap = true, silent = true })

-- https://github.com/terrortylor/nvim-comment
require('nvim_comment').setup()

-- https://github.com/catppuccin/nvim catppuccin

-- https://github.com/balazs4/zeitgeist
vim.cmd("colorscheme zeitgeist")

-- https://github.com/nvim-treesitter/nvim-treesitter
require('nvim-treesitter.configs').setup({
  highlight = { enable = true }
})
