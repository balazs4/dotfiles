vim.cmd('colorscheme retrobox') -- $HOME/.files/.config/nvim/colors/zzz.lua
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

vim.keymap.set('n', '<leader>`', ':buffers<CR>:buffer ')
vim.keymap.set('n', '<leader><Tab>', ':buffers<CR>:buffer ')
vim.keymap.set('n', '`', '<C-^>')
vim.keymap.set('n', '<leader><cr>', ':wa | silent make | source $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>y', function() vim.lsp.buf.document_symbol({}) end)
vim.keymap.set('n', '<leader>Y', function() vim.lsp.buf.workspace_symbol('',{}) end )
vim.keymap.set('v', ',,', ':!emmet<CR>')
vim.keymap.set('n', '<C-j>', ':cnext<CR>zz');
vim.keymap.set('n', '<C-k>', ':cprevious<CR>zz');
vim.keymap.set('n', '<leader>w', ':grep <cword>| copen <CR>')
vim.keymap.set('n', '<leader>W', ':grep <cWORD> | copen <CR>')
vim.keymap.set('n', '<leader>q', ':grep <cword> %:.:h')

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
    vim.keymap.set('n', '<leader>b', vim.diagnostic.setqflist, { buffer = args.buf })


    if tostring(vim.version()):match('0.11') and client.supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
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

    if args.data.params.value.kind == 'report' then
      msg = string.format('%s\tmessage=%s\tpercentage=%s',
        msg,
        args.data.params.value.message,
        args.data.params.value.percentage
      )
    end

    vim.notify_once(msg, vim.log.levels.INFO)
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

--- @param files table project markers
--- @return string|nil
local function get_root_dir(files)
  local cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
  local git_root_dir = vim.fs.root(0, '.git')

  for _, file in ipairs(files) do
    if git_root_dir and vim.fs.root(git_root_dir, file) then
      return git_root_dir
    end
    if vim.fs.root(cwd, file) then
      return cwd
    end
  end

  return nil
end

--- @param files table project markers
--- @param cmd table lsp server command
--- @return vim.lsp.ClientConfig|nil
local function configure(files, cmd)
  local root_dir = get_root_dir(files)
  if root_dir == nil then return end
  return { cmd = cmd, name = cmd[1], root_dir = root_dir }
end

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

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  callback = function()
    local config = nil
    config = configure({ 'node_modules/.bin/tsserver' }, { 'typescript-language-server', '--stdio' })
    if config ~= nil then
      config.on_attach = function(_, bufnr)
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

      vim.lsp.start(config)
      return
    end

    config = configure({ 'deno.lock', 'deno.json' }, { 'deno', 'lsp' })
    if config ~= nil then
      vim.lsp.start(config)
      return
    end
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go' },
  callback = function()
    local cfg = configure({ 'go.mod', 'go.work' }, { 'gopls' })
    if cfg ~= nil then
      vim.lsp.start({ cmd = cfg.cmd, name = cfg.name, root_dir = cfg.root_dir })
    end
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'terraform' },
  callback = function()
    local cfg = configure({ '.terrform.lock.hcl' }, { 'terraform-ls', 'serve' })
    if cfg ~= nil then
      vim.lsp.start({ cmd = cfg.cmd, name = cfg.name, root_dir = cfg.root_dir })
    end
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'rust' },
  callback = function()
    local cfg = configure({ 'Cargo.toml' }, { 'rust-analyzer' })
    if cfg ~= nil then
      vim.lsp.start({ cmd = cfg.cmd, name = cfg.name, root_dir = cfg.root_dir })
    end
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua' },
  callback = function()
    vim.treesitter.stop()
    local cfg = configure({ '.luarc.json', '.git' }, { 'lua-language-server' })
    if cfg ~= nil then
      vim.lsp.start({ cmd = cfg.cmd, name = cfg.name, root_dir = cfg.root_dir, settings = { Lua = { workspace = { library = vim.api.nvim_list_runtime_paths() } } } })
    end
  end
})

-- https://github.com/ibhagwan/fzf-lua
require('fzf-lua').setup({
  'default',
  winopts = {
    fullscreen = false,
    preview = { layout = 'vertical' }
  }
})
vim.keymap.set('n', '<leader>-', require('fzf-lua').builtin)

-- https://github.com/echasnovski/mini.comment
require('mini.comment').setup({
  options = {
    ignore_blank_line = true
  }
})

-- https://github.com/vijaymarupudi/nvim-fzf
require("fzf").default_options = {
  relative = 'editor',
  window_on_create = function()
    vim.cmd("set winhl=Normal:Normal")
  end
}

vim.keymap.set('n', '<leader><leader>', function()
  coroutine.wrap(function()
    local result = require('fzf').fzf('git ls-files', '--ansi --expect=ctrl-v', { relative = 'editor' })
    if not result then return end

    if result[1] == 'ctrl-v'
    then
      vim.cmd(string.format('vsplit %s', result[2]))
      return
    end

    vim.cmd(string.format('edit %s', result[2]))
  end)()
end)
