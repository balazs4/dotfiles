--carbon vim.cmd('colorscheme base16')
--mcbpro vim.cmd('colorscheme base16')
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.guicursor = 'i:block'
vim.opt.termguicolors = true
vim.opt.completeopt = 'fuzzy,menuone,noselect,popup'
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
vim.opt.winborder = 'rounded'

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_altv = 1

vim.opt.grepprg = 'rg --vimgrep --hidden'

if os.getenv('PWD') == string.format('%s/.files', os.getenv('HOME')) then
  vim.keymap.set('n', '<leader><cr>', ':w | !make $HOME/%<CR>')
end

vim.keymap.set('n', '`', ':buffers<CR>:buffer ')
vim.keymap.set('n', '<C-j>', ':cnext<CR>zz');
vim.keymap.set('n', '<C-k>', ':cprevious<CR>zz');
vim.keymap.set('n', '<leader>w', ':silent grep <cword>| copen <CR>')
vim.keymap.set('n', '<leader>W', ':silent grep <cWORD> | copen <CR>')
vim.keymap.set('n', '<leader>q', ':silent grep <cword> %:.:h | copen <CR>')
vim.keymap.set('v', '<C-y>,', ':!emmet<CR> | ==')
vim.keymap.set('i', '<C-z>,', '<C-o>V :!emmet<CR> <C-o>==')

vim.keymap.set('n', '<leader>g', function()
  local git_root_dir = vim.fs.root(0, '.git')
  if not git_root_dir then return end

  local filename = string.gsub(vim.api.nvim_buf_get_name(0), git_root_dir, '')
  local row = vim.api.nvim_win_get_cursor(0)[1]

  local cmd = string.format("!gh browse '%s':%d", filename, row)

  vim.cmd(cmd)
end)

vim.api.nvim_create_autocmd('Signal', { callback = function(_) vim.cmd(string.format("source $MYVIMRC")) end })

local function update_statusline(_)
  vim.opt.statusline = '%<%f %h%w%m%r%=%-14.(%l,%c%V%) %P' -- :help statusline
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    local prefix = string.format('[%s] ', client.name)
    ---@diagnostic disable-next-line
    vim.opt.statusline:prepend(prefix);
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
      severity_sort = true,
      signs = false,
      underline = true,
      update_in_insert = false,
      virtual_text = { spacing = 4, source = true, severity = vim.diagnostic.severity.HINT }
    })

    vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

    vim.keymap.set('n', '<leader>T', vim.diagnostic.open_float, { buffer = args.buf })
    vim.keymap.set('n', '<leader>b', vim.diagnostic.setqflist, { buffer = args.buf })
    vim.keymap.set('n', '<leader>p', function() vim.lsp.buf.format({ async = true }) end, { buffer = args.buf })

    if client:supports_method('textDocument/documentColor') then
      vim.lsp.document_color.enable(true, args.buf)
    end
  end,
})

vim.api.nvim_create_autocmd('LspDetach', { callback = function(_) update_statusline() end })
vim.api.nvim_create_autocmd('BufEnter', { callback = function() update_statusline() end })

---toggle filename between .ts and test.ts
---@param suffix string non test suffix (e.g. .ts, .go)
---@param test_suffix string test suffix (e.g. .test.ts, _test.go)
---@param mode? string
---@return string
local function counterpart(suffix, test_suffix, mode)
  local buffer = vim.api.nvim_buf_get_name(0)
  local is_test_in_buffer = buffer:sub(- #test_suffix) == test_suffix

  if is_test_in_buffer and mode == 'ensure_test' then
    return buffer
  end

  local filename = is_test_in_buffer
      and string.gsub(buffer, string.format("%s$", test_suffix), suffix)
      or string.gsub(buffer, string.format("%s$", suffix), test_suffix)

  return filename
end

vim.lsp.config('*', { root_markers = { '.git' } })

vim.lsp.enable('gopls')
vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go' },
  root_markers = { 'go.mod', 'go.work' },
  settings = { completeUnimported = true },
  on_attach = function(_, bufnr)
    vim.keymap.set('n', '<leader>t', function()
      local filename = counterpart('.go', '_test.go')
      local cmd = string.format('vsplit %s', filename)
      vim.cmd(cmd)
    end, { buffer = bufnr })
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

vim.lsp.enable('vscode-json-language-server');
vim.lsp.config('vscode-json-language-server', {
  cmd = { 'bun', 'x', '--bun', '-p', 'vscode-langservers-extracted', 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json' },
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


local typescript_language_server = {
  name = 'vtsls',
  cmd = { 'bun', 'x', '--bun', '-p', '@vtsls/language-server', 'vtsls', '--stdio' }
}

if os.getenv('NVIM_LSP_TSGO') == '1' then
  typescript_language_server.name = 'tsgo'
  typescript_language_server.cmd = { vim.loop.os_homedir() .. '/src/typescript-go/built/local/tsgo', '--lsp', '--stdio' }
end

vim.lsp.enable(typescript_language_server.name)
vim.lsp.config(typescript_language_server.name, {
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  cmd = typescript_language_server.cmd,
  root_markers = { 'tsconfig.json', 'jsconfig.json' },
  workspace_required = true,
  on_attach = function(client, bufnr)
    vim.keymap.set('n', '<leader>t', function()
      local filename = counterpart('.ts', '.test.ts')
      local cmd = string.format('vsplit %s', filename)
      vim.cmd(cmd)
    end, { buffer = bufnr })

    vim.keymap.set('n', '<leader>r',
      function()
        local test_file = counterpart('.ts', '.test.ts', 'ensure_test')
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
vim.opt.path:append('**')
