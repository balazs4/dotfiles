--carbon vim.cmd('colorscheme base16')
--mcbpro vim.cmd('colorscheme base16')
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.guicursor = 'i:block'
vim.opt.termguicolors = true
vim.opt.completeopt = 'menuone,noselect,popup'
vim.opt.cursorline = false
vim.opt.nu = true
vim.opt.rnu = true
vim.opt.list = true
vim.opt.listchars = "tab:  ,trail:·,eol: ,nbsp:_"
vim.opt.cmdheight = 1
vim.opt.cursorline = true
vim.opt.undofile = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.showcmd = false
vim.opt.wrap = false

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_altv = 1

vim.opt.grepprg = 'rg --vimgrep --hidden'

vim.keymap.set('n', 'H', '^')
vim.keymap.set('n', 'L', '$')
vim.keymap.set('n', '`', ':buffers<CR>:buffer ')
vim.keymap.set('n', '<leader>`', ':bd<CR>')
vim.keymap.set('n', '<leader><cr>', ':w | !make %<CR>') --TODO: set it only if $PWD === $HOME/.files and source $MYVIMRC only if % === .config/nvim/init.lua
vim.keymap.set('n', '<C-j>', ':cnext<CR>zz');
vim.keymap.set('n', '<C-k>', ':cprevious<CR>zz');
vim.keymap.set('n', '<leader>w', ':silent grep <cword>| copen <CR>')
vim.keymap.set('n', '<leader>W', ':silent grep <cWORD> | copen <CR>')
vim.keymap.set('n', '<leader>q', ':silent grep <cword> %:.:h | copen <CR>')
vim.keymap.set('v', '<C-y>,', ':!emmet<CR> | ==')
vim.keymap.set('i', '<C-z>,', '<C-o>V :!emmet<CR> <C-o>==')

-- copied from https://yobibyte.github.io/vim.html
vim.keymap.set("n", "<leader>c", function()
  vim.ui.input({}, function(c)
    if c and c ~= "" then
      vim.cmd("noswapfile vnew")
      vim.bo.buftype = "nofile"
      vim.bo.bufhidden = "wipe"
      vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.systemlist(c))
    end
  end)
end)

vim.keymap.set('n', '<leader>g', function()
  local git_root_dir = vim.fs.root(0, '.git')
  if not git_root_dir then return end

  local filename = string.gsub(vim.api.nvim_buf_get_name(0), git_root_dir, '')
  local row = vim.api.nvim_win_get_cursor(0)[1]

  local cmd = string.format("!gh browse '%s':%d", filename, row)

  vim.cmd(cmd)
end)

vim.api.nvim_create_autocmd('Signal', {
  callback = function(args)
    vim.cmd(string.format("source $MYVIMRC"))
  end
})

local function update_statusline(_)
  vim.opt.statusline = '%<%f %h%w%m%r%=%-14.(%l,%c%V%) %P' -- :help statusline
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    vim.opt.statusline:prepend(string.format('[%s] ', client.name));
  end
end


vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    update_statusline() -- see LspDetach, BufEnter

    vim.api.nvim_create_user_command("LspInfo", function() print(vim.inspect(vim.lsp.get_clients())) end, {})
    vim.api.nvim_create_user_command("LspStop", function() vim.lsp.stop_client(vim.lsp.get_clients(), true) end, {})

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then return end

    vim.diagnostic.config({
      update_in_insert = false,
      signs = false,
      underline = { severity = vim.diagnostic.severity.ERROR },
      virtual_text = { severity = vim.diagnostic.severity.ERROR, spacing = 4, source = true },
      severity_sort = true
    })

    vim.keymap.set('n', '<leader>T', vim.diagnostic.open_float, { buffer = args.buf })
    vim.keymap.set('n', '<leader>p', function() vim.lsp.buf.format({ async = true }) end, { buffer = args.buf })
    vim.keymap.set('n', '<leader>y', function() vim.lsp.buf.document_symbol({}) end, { buffer = args.buf })
    vim.keymap.set('n', '<leader>Y', function() vim.lsp.buf.workspace_symbol('', {}) end, { buffer = args.buf })

    vim.keymap.set('n', '<leader>d', function()
      vim.cmd('vsplit')
      vim.lsp.buf.definition()
    end, { buffer = args.buf })
    vim.keymap.set('n', '<leader>b', function()
      vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
    end, { buffer = args.buf })

    vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

    if client:supports_method('textDocument/documentColor')
    then
      vim.lsp.document_color.enable(true, args.buf)
    end
  end,
})


vim.api.nvim_create_autocmd('LspDetach', {
  callback = function(args)
    update_statusline()
  end
})

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function(args)
    update_statusline()
  end
})

vim.lsp.config('*', { root_markers = { '.git' } })

vim.lsp.enable('gopls')
vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go' },
  root_markers = { 'go.mod', 'go.work' },
  settings = { completeUnimported = true },
  on_attach = function(_, _)
    vim.keymap.set('n', 'gxx', '"nyi\' :!xdg-open https://<C-R>n <CR>')
  end
})

--mcbpro vim.lsp.enable('terraform-ls')
vim.lsp.config('terraform-ls', {
  cmd = { 'terraform-ls', 'serve' },
  filetypes = { 'terraform' },
  root_markers = { '.terrform.lock.hcl' },
  workspace_required = false,
  settings = {
    ignoreSingleFileWarning = true
  }
})

vim.lsp.enable('vscode-css-language-server');
vim.lsp.config('vscode-css-language-server', {
  cmd = { 'bun', 'x', '--bun', '-p', 'vscode-langservers-extracted', 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css' },
})

vim.lsp.enable('svelteserver')
vim.lsp.config('svelteserver', {
  cmd = { 'bun', 'x', '--bun', '-p', 'svelte-language-server', 'svelteserver', '--stdio' },
  filetypes = { 'svelte' },
  root_markers = { 'svelte.config.js' },
  workspace_required = true
})

vim.lsp.enable('yaml-language-server');
vim.lsp.config('yaml-language-server', {
  cmd = { 'bun', 'x', '--bun', 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml' },
})

vim.lsp.enable('lua-language-server')
vim.lsp.config('lua-language-server', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json' },
  settings = { Lua = { workspace = { library = vim.api.nvim_list_runtime_paths() } } },
})

vim.lsp.enable('csharp-ls');
vim.lsp.config('csharp-ls', {
  cmd = { 'csharp-ls' },
  root_markers = { 'obj' },
  filetypes = { 'cs' },
  init_options = {
    AutomaticWorkspaceInit = true,
  },
})

vim.lsp.enable('deno')
vim.lsp.config('deno', {
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  cmd = { 'deno', 'lsp' },
  root_markers = { 'deno.lock', 'deno.json' },
  workspace_required = true
})


vim.lsp.enable('biome')
vim.lsp.config('biome', {
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  cmd = { './node_modules/@biomejs/biome/bin/biome', 'lsp-proxy' },
  root_markers = { 'biome.json', 'biome.jsonc' },
  workspace_required = true
})

local tsgo_enabled = false
vim.lsp.enable('tsgo', tsgo_enabled)
vim.lsp.config('tsgo', {
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  cmd = { vim.loop.os_homedir() .. '/src/typescript-go/built/local/tsgo', '--lsp', '--stdio' },
  root_markers = { 'tsconfig.json', 'jsconfig.json' },
  workspace_required = true
})

vim.lsp.enable('vtsls', not tsgo_enabled)
vim.lsp.config('vtsls', {
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  cmd = { 'bun', 'x', '--bun', '-p', '@vtsls/language-server', 'vtsls', '--stdio' },
  root_markers = { 'tsconfig.json', 'jsconfig.json' },
  workspace_required = true,
  on_attach = function(client, bufnr)
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

    vim.keymap.set('n', '<leader>t', function() vim.cmd(string.format('vsplit %s', ts_test_ts())) end, { buffer = bufnr })

    vim.keymap.set('n', '<leader>r',
      function()
        local test_file = ts_test_ts('ensure_test_ts')
        local cmd = string.format(
          'while true; do LOG_LEVEL=info NPM_CONFIG_LOGLEVEL=error npm run test -- --verbose --forceExit %s; git ls-files | changing - && clear || break; done',
          test_file);
        vim.cmd(string.format('!tmux split-window -d -c $(dirname %s) -h "%s"', test_file, cmd))
      end, { buffer = bufnr })

    -- biome should format
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
})


vim.opt.runtimepath:append("~/.fzf")
vim.keymap.set('n', '<leader><leader>', '<cmd>FZF<cr>')
