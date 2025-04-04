vim.cmd('colorscheme base16')
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.guicursor = 'i:block'
vim.opt.termguicolors = true
vim.opt.completeopt = 'menuone,noselect,popup'
vim.opt.cursorline = false
vim.opt.nu = true
vim.opt.rnu = false
vim.opt.list = true
vim.opt.listchars = "tab:  ,trail:·,eol: ,nbsp:_"
vim.opt.cmdheight = 2
vim.opt.cursorline = true
vim.opt.undofile = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_altv = 1

vim.opt.grepprg = 'rg --vimgrep --hidden'

vim.keymap.set('n', 'H', '^')
vim.keymap.set('n', 'L', '$')
vim.keymap.set('n', '<leader>`', ':buffers<CR>:buffer ')
vim.keymap.set('n', '`', '<C-^>')
vim.keymap.set('n', '<leader><cr>', ':wa | silent make | source $MYVIMRC<CR>')
vim.keymap.set('n', '<C-j>', ':cnext<CR>zz');
vim.keymap.set('n', '<C-k>', ':cprevious<CR>zz');
vim.keymap.set('n', '<leader>w', ':silent grep <cword>| copen <CR>')
vim.keymap.set('n', '<leader>W', ':silent grep <cWORD> | copen <CR>')
vim.keymap.set('n', '<leader>q', ':silent grep <cword> %:.:h | copen <CR>')

vim.keymap.set('n', '<leader>g', function()
  local git_root_dir = vim.fs.root(0, '.git')
  if not git_root_dir then return end

  local filename = string.gsub(vim.api.nvim_buf_get_name(0), git_root_dir, '')
  local row = vim.api.nvim_win_get_cursor(0)[1]

  local cmd = string.format("!gh browse '%s':%d", filename, row)

  vim.cmd(cmd)
end)

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.diagnostic.config({
      update_in_insert = false,
      signs = false,
      underline = { severity = vim.diagnostic.severity.ERROR },
      virtual_text = { severity = vim.diagnostic.severity.ERROR, spacing = 4 },
      severity_sort = true,
      source = true
    })

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then return end

    vim.api.nvim_create_user_command("LspInfo", function() print(vim.inspect(client)) end, {})
    vim.api.nvim_create_user_command("LspStop", function() client.stop() end, {})

    vim.keymap.set('n', '<leader>T', vim.diagnostic.open_float, { buffer = args.buf })
    vim.keymap.set('n', '<leader>p', vim.lsp.buf.format, { buffer = args.buf })
    vim.keymap.set('n', '<leader>b',
      function() vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR }) end, { buffer = args.buf })
    vim.keymap.set('n', '<leader>y', function() vim.lsp.buf.document_symbol({}) end)
    vim.keymap.set('n', '<leader>Y', function() vim.lsp.buf.workspace_symbol('', {}) end)
    vim.keymap.set('n', '<leader>d', function()
      vim.cmd('vsplit')
      vim.lsp.buf.definition()
    end, { buffer = args.buf })

    vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
  end,
})

vim.api.nvim_create_autocmd('LspProgress', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then return end

    local msg = string.format("[Lsp:%s]\tevent=LspProgress\tkind=%s\ttitle=%s",
      client.name,
      args.data.params.value.kind,
      args.data.params.value.title
    )

    vim.notify_once(msg, vim.log.levels.INFO)
    -- TODO: add permanent lsp marker to cmd
  end,
})

vim.api.nvim_create_autocmd('LspRequest', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then return end

    local msg = string.format("[Lsp:%s]\tevent=LspRequest\tmethod=%s\ttype=%s",
      client.name,
      args.data.request.method,
      args.data.request.type
    )

    vim.notify_once(msg, vim.log.levels.INFO)
  end,
})

vim.lsp.config('*', { root_markers = { '.git' } })


vim.lsp.enable('gopls')
vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go' },
  root_markers = { 'go.mod', 'go.work' },
})

vim.lsp.enable('terraform-ls')
vim.lsp.config('terraform-ls', {
  cmd = { 'terraform-ls', 'serve' },
  filetypes = { 'terraform' },
  root_markers = { '.terrform.lock.hcl' }
})

vim.lsp.enable('vscode-css-language-server');
vim.lsp.config('vscode-css-language-server', {
  cmd = { 'bun', 'x', '-p', 'vscode-langservers-extracted', 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css' },
})

vim.lsp.enable('svelteserver')
vim.lsp.config('svelteserver', {
  cmd = { 'bun', 'x', '-p', 'svelte-language-server', 'svelteserver', '--stdio' },
  filetypes = { 'svelte' },
  root_markers = { 'svelte.config.js' },
})

vim.lsp.enable('yaml-language-server');
vim.lsp.config('yaml-language-server', {
  cmd = { 'bun', 'x', 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml' },
})

vim.lsp.enable('lua-language-server')
vim.lsp.config('lua-language-server', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json' },
  settings = { Lua = { workspace = { library = vim.api.nvim_list_runtime_paths() } } }
})

--carbon vim.lsp.enable('deno')
vim.lsp.config('deno', {
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  cmd = { 'deno', 'lsp' },
  root_markers = { 'deno.lock', 'deno.json' }
})

--mcbpro vim.lsp.enable('vstls')
vim.lsp.config('vstls', {
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  cmd = { 'bun', 'x', '-p', '@vtsls/language-server', 'vtsls', '--stdio' },
  root_markers = { 'node_modules/.bin/tsserver', 'tsconfig.json', 'jsconfig.json' },
  on_attach = function(_, bufnr)

    ---toggle filename between .ts and test.ts
    ---@param mode? string
    ---@return string
    local function ts_test_ts(mode)
      local buffer = vim.api.nvim_buf_get_name(0)
      local is_test_ts = buffer:sub(- #'test.ts') == 'test.ts'

      if is_test_ts and mode == 'ensure_test_ts' then
        return buffer
      end

      local filename = is_test_ts
          and string.gsub(buffer, ".test.ts$", ".ts")
          or string.gsub(buffer, ".ts$", ".test.ts")

      return filename
    end

    pcall(vim.keymap.del, 'n', '<leader>p')
    vim.keymap.set('n', '<leader>p',
      function()
        vim.cmd('wa | !gfmt')
      end, { buffer = bufnr })

    vim.keymap.set('n', '<leader>t',
      function()
        local cmd = string.format('vsplit %s', ts_test_ts())
        vim.cmd(cmd)
      end, { buffer = bufnr })

    vim.keymap.set('n', '<leader>r',
      function()
        local cmd = string.format('!tmux split-window -h "npmw test %s --verbose"', ts_test_ts('ensure_test_ts'))
        vim.cmd(cmd)
      end, { buffer = bufnr })
  end
})

vim.opt.runtimepath:append("~/.fzf")
vim.keymap.set('n', '<leader><leader>', '<cmd>FZF<cr>')
