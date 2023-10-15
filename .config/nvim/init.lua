-- Linux Darwin

vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.guicursor = 'i:block'
vim.opt.termguicolors = true
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.cursorline = false
vim.opt.nu = true
vim.opt.rnu = true
vim.opt.list = true
vim.opt.listchars = "tab:  ,trail:·,eol: ,nbsp:_"
vim.opt.cmdheight = 1
vim.cmd('let g:loaded_matchparen=1')

vim.keymap.set('n', '<leader>g', function()
  local filename = string.gsub(vim.fn.expand('%'), os.getenv('PWD') or "", "")
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.cmd('! gh browse ' .. filename .. ':' .. row)
end, { noremap = true, silent = true })

vim.diagnostic.config({
  signs = false, update_in_insert = false, underline = false
  ,virtual_text = { severity = vim.diagnostic.severity.ERROR , spacing = 4 },
})

vim.keymap.set('n', '<C-]>', vim.lsp.buf.definition, { noremap = true, silent = true})
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true})
vim.keymap.set('n', 'gR', vim.lsp.buf.rename, { noremap = true, silent = true})
vim.keymap.set('n', '<leader>p', function() vim.lsp.buf.format { async = true } end, { noremap = true, silent = true} )
vim.keymap.set('n', '<leader>T', vim.diagnostic.open_float, { noremap = true, silent = true })
vim.keymap.set('i', '<C-N>', '<C-X><C-O>', { noremap = true, silent = true})


function lsp(pattern, cmd, project, setup)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = pattern,
    callback = function()
      local client = vim.lsp.start({ name = pattern[1], cmd = cmd, root_dir = vim.fs.dirname( vim.fs.find(project, { upward = true })[1]) })
      vim.lsp.buf_attach_client(0, client)
      print("lsp:" .. pattern[1] .. " > " .. cmd[1])
      if setup then setup() end
    end
  })
end

lsp({'go', 'templ'}, {'gopls'}, {'go.mod'})
lsp({'rust'}, {'rust-analyzer'}, {'Cargo.toml'})
--carbon lsp({'javascript', 'typescript'}, {'deno', 'lsp'}, {'deno.json'})
--mcbpro lsp({'typescript', 'typescriptreact'}, {'typescript-language-server', '--stdio'}, {'tsconfig.json'},
--mcbpro   function()
--mcbpro     vim.keymap.set('n', '<leader>t', function()
--mcbpro       local filename = vim.fn.expand('%')
--mcbpro       local targetfilename = filename:sub(-string.len('test.ts')) == 'test.ts'
--mcbpro           and string.gsub(filename, ".test.ts$", ".ts")
--mcbpro           or string.gsub(filename, ".ts$", ".test.ts")
--mcbpro
--mcbpro       vim.cmd('vsplit ' .. targetfilename)
--mcbpro     end, { noremap = true, silent = true })
--mcbpro
--mcbpro     vim.keymap.set('n', '<leader>r', function()
--mcbpro       local filename = vim.fn.expand('%')
--mcbpro       local workspace = {}
--mcbpro       for p in string.gmatch(filename, "([^/]+)") do table.insert(workspace, p) end
--mcbpro
--mcbpro       local testfilename = filename:sub(-string.len('test.ts')) == 'test.ts'
--mcbpro           and filename
--mcbpro           or string.gsub(filename, ".ts$", ".test.ts")
--mcbpro
--mcbpro       vim.cmd('! tmux split-window pnpm --filter ' .. workspace[2] .. ' test -- --watch ' .. testfilename)
--mcbpro       vim.cmd('! tmux select-pane -l')
--mcbpro       vim.cmd('! tmux send-keys Enter')
--mcbpro     end, { noremap = true, silent = true })
--mcbpro   end
--mcbpro )

-- prettier
vim.api.nvim_create_autocmd('FileType', {
  pattern = {'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'html', 'md', 'json'},
  callback = function()
    vim.keymap.del('n', '<leader>p')
    vim.keymap.set('n', '<leader>p', function()
      vim.cmd(':w %')
      local filename = vim.fn.expand('%')
      vim.cmd('! bun x prettier --write ' .. filename)
      vim.cmd(':e %')
    end, { noremap = true, silent = true })
  end
})

-- https://github.com/ibhagwan/fzf-lua
require('fzf-lua').setup { 'default', winopts = { fullscreen = false, preview = { layout = 'vertical' } } }
vim.keymap.set('n', '<leader>-', require('fzf-lua').builtin, { noremap = true, silent = true })
vim.keymap.set('n', '<leader><leader>', require('fzf-lua').files, { noremap = true, silent = true })
vim.keymap.set('n', '``', require('fzf-lua').buffers, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>=', require('fzf-lua').grep_project, { noremap = true, silent = true })
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

-- https://github.com/balazs4/zeitgeist
vim.cmd("colorscheme zeitgeist")

-- https://github.com/nvim-treesitter/nvim-treesitter
require('nvim-treesitter.configs').setup({
  highlight = { enable = true },
  ensure_installed = { 'lua', 'typescript', 'javascript', 'go', 'rust' }
})

-- https://github.com/mattn/emmet-vim
vim.g.user_emmet_leader_key='<C-Z>'

-- https://github.com/tinted-theming/base16-vim
vim.g.base16_background_transparent = 1
vim.cmd("colorscheme base16-ayu-dark")
