vim.cmd('colorscheme base16') -- $HOME/.files/.config/nvim/colors/
vim.api.nvim_command("hi Normal guibg=none ctermbg=none")
vim.api.nvim_command("hi NonText guibg=none ctermbg=none")
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
vim.opt.cursorline = true

-- theprimeagen
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set('n', '<leader>g', function()
  local filename = string.gsub(vim.fn.expand('%'), os.getenv('PWD') or "", "")
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.cmd('! gh browse ' .. filename .. ':' .. row)
end, { noremap = true, silent = true })

vim.diagnostic.config({
  signs = false,
  update_in_insert = false,
  underline = false,
  virtual_text = { severity = vim.diagnostic.severity.ERROR, spacing = 4 }
})

local function lsp(pattern, cmd, project_file, setup)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = pattern,
    callback = function()
      local root_dir = vim.fs.dirname(
        vim.fs.find(project_file and project_file or vim.fn.expand('%'), { upward = true })[1]
      )

      local client = vim.lsp.start({ name = pattern[1], cmd = cmd, root_dir = root_dir })
      vim.lsp.buf_attach_client(0, client)

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>p', function() vim.lsp.buf.format({ async = true }) end,
        { noremap = true, silent = true })
      vim.keymap.set('n', 'gR', vim.lsp.buf.rename, { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>T', vim.diagnostic.open_float, { noremap = true, silent = true })

      if setup then setup(client) end
    end
  })
end

vim.api.nvim_create_user_command("LspRestart",
  function()
    vim.lsp.stop_client(vim.lsp.get_active_clients(), false)
    vim.wait(500)
    vim.cmd(':edit')
  end,
  {}
)

vim.api.nvim_create_user_command("LspInfo",
  function()
    vim.cmd(":lua= vim.lsp.get_active_clients()")
  end,
  {}
)

lsp({ 'go' }, { 'gopls' }, { 'go.mod' })
lsp({ 'templ' }, { 'templ', 'lsp' }, { 'go.mod' })
lsp({ 'lua' }, { 'lua-language-server' }, { '.luarc.json' })
lsp({ 'rust' }, { 'rust-analyzer' }, { 'Cargo.toml' })
lsp({ 'terraform' }, { 'terraform-ls', 'serve' }, { '.terrform.lock.hcl' })
--carbon lsp({'typescript'}, {'deno', 'lsp'}, {'deno.json'})
lsp({ 'typescript', 'typescriptreact' }, { 'typescript-language-server', '--stdio' }, { 'tsconfig.json' },
  function()
    pcall(vim.keymap.del, 'n', '<leader>p')
    vim.keymap.set('n', '<leader>p', function() vim.cmd(':PrettierAsync') end, { noremap = true, silent = true })

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

      vim.cmd('! tmux split-window -h pnpm --filter ' .. workspace[2] .. ' test -- --watch ' .. testfilename)
      vim.cmd('! tmux select-pane -l')
      vim.cmd('! tmux send-keys Enter')
    end, { noremap = true, silent = true })
  end
)

-- https://github.com/ibhagwan/fzf-lua
require('fzf-lua').setup({
  'default',
  winopts = {
    fullscreen = false,
    preview = { layout = 'vertical' }
  },
  colorschemes = {
    post_reset_cb = function()
      -- TODO
    end
  }
})

vim.keymap.set('n', '<leader>-', require('fzf-lua').builtin, { noremap = true, silent = true })
vim.keymap.set('n', '<leader><leader>', require('fzf-lua').files, { noremap = true, silent = true })
vim.keymap.set('n', '``', require('fzf-lua').buffers, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>=', require('fzf-lua').grep_project, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>w', require('fzf-lua').grep_cword, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>W', require('fzf-lua').grep_cWORD, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>/', require('fzf-lua').blines, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>`', require('fzf-lua').git_status, { noremap = true, silent = true })

vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, { noremap = true, silent = true })
vim.keymap.set('n', 'ga', require('fzf-lua').lsp_code_actions, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>b', require('fzf-lua').lsp_document_diagnostics, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>y', require('fzf-lua').lsp_document_symbols, { noremap = true, silent = true })


-- https://github.com/nvim-treesitter/nvim-treesitter
require('nvim-treesitter.configs').setup({
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  ensure_installed = { 'lua', 'typescript', 'javascript', 'go' }
})
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

-- https://github.com/vrischmann/tree-sitter-templ
require('tree-sitter-templ').setup({ highlight = { enable = true } })

-- https://github.com/mattn/emmet-vim
vim.g.user_emmet_leader_key = '<C-Z>'

-- https://github.com/prettier/vim-prettier

-- https://github.com/echasnovski/mini.completion
require('mini.completion').setup()

-- https://github.com/echasnovski/mini.surround
require('mini.surround').setup()

-- https://github.com/echasnovski/mini.comment
require('mini.comment').setup()
