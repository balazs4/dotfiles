vim.cmd('colorscheme zzz') -- $HOME/.files/.config/nvim/colors/zzz.lua
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
vim.opt.cmdheight = 1
vim.opt.cursorline = true
vim.opt.undofile = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

vim.keymap.set('n', '<cr><cr>', function() vim.cmd('wa | silent make | source $MYVIMRC | normal `.') end)

vim.keymap.set('n', '<leader>g', function()
  local filename = string.gsub(vim.fn.expand('%'), os.getenv('PWD') or "", "")
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.cmd("! gh browse '" .. filename .. "':" .. row)
end)

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.opt.cmdheight = 2

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

    vim.keymap.set('n', '<leader>p', function() vim.lsp.buf.format({ async = true }) end, { buffer = args.buf })
    vim.keymap.set('n', '<leader>T', vim.diagnostic.open_float, { buffer = args.buf })

    if vim.fn.has("nvim-0.11") == 0 and client.supports_method('textDocument/completion') then
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
    if vim.fs.root(cwd, file) then
      return cwd
    end
    if git_root_dir and vim.fs.root(git_root_dir, file) then
      return git_root_dir
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

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  callback = function()
    local config = nil
    config = configure({ 'node_modules/.bin/tsserver' }, { 'typescript-language-server', '--stdio' })
    if config ~= nil then
      local function filename(mode)
        local buffer = vim.fn.expand('%')
        if buffer:sub(-string.len('test.ts')) == 'test.ts' then
          if mode == 'ensure_test_ts' then
            return buffer
          else
            return string.gsub(buffer, ".test.ts$", ".ts")
          end
        end
        return string.gsub(buffer, ".ts$", ".test.ts")
      end

      vim.lsp.start({
        cmd = config.cmd,
        name = config.name,
        root_dir = config.root_dir,
        on_attach = function(_, bufnr)
          pcall(vim.keymap.del, 'n', '<leader>p')
          vim.keymap.set('n', '<leader>p', function() vim.cmd('wa | !gfmt') end, { buffer = bufnr })
          vim.keymap.set('n', '<leader>t', function() vim.cmd('vsplit ' .. filename('toggle')) end, { buffer = bufnr })
          vim.keymap.set('n', '<leader>r',
            function() vim.cmd('! tmux split-window -h "npmw test ' .. filename('ensure_test_ts') .. ' --verbose "') end,
            { buffer = bufnr })
          vim.keymap.set('n', '<leader>B', function() vim.cmd('! tmux split-window -h "git blame % | vipe -"') end,
            { buffer = bufnr })
        end
      })
      return
    end

    config = configure({ 'deno.lock', 'deno.json' }, { 'deno', 'lsp' })
    if config ~= nil then
      vim.lsp.start({ cmd = config.cmd, name = config.name, root_dir = config.root_dir })
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
    local cfg = configure({ '.luarc.json' }, { 'lua-language-server' })
    if cfg ~= nil then
      vim.lsp.start({ cmd = cfg.cmd, name = cfg.name, root_dir = cfg.root_dir })
    end
  end
})

-- https://github.com/ibhagwan/fzf-lua
require('fzf-lua').setup({
  'default',
  winopts = {
    fullscreen = false,
    preview = { layout = 'vertical' }
  },
  grep = {
    rg_opts = "--sort-files --hidden --column --line-number --no-heading --smart-case  -g '!{.git,node_modules}/*'",
  }
})

vim.keymap.set('n', '``', require('fzf-lua').buffers)
vim.keymap.set('n', '<leader>-', require('fzf-lua').builtin)
vim.keymap.set('n', '<leader><leader>', function() require('fzf-lua').files({ resume = false }) end)
vim.keymap.set('n', '<leader>[', function() require('fzf-lua').files({ resume = true }) end)
vim.keymap.set('n', '<leader>=', require('fzf-lua').grep_project)
vim.keymap.set('n', '<leader>w', require('fzf-lua').grep_cword)
vim.keymap.set('n', '<leader>W', require('fzf-lua').grep_cWORD)
vim.keymap.set('v', '<leader>w', require('fzf-lua').grep_visual)
vim.keymap.set('n', '<leader>/', require('fzf-lua').blines)
vim.keymap.set('n', '<leader>0', require('fzf-lua').resume)
vim.keymap.set('n', '<leader>]',
  function()
    local _file = vim.fn.expand('%')
    local _cwd = vim.fs.dirname(_file)
    local cwd = vim.fn.input("grep.cwd=", _cwd, "dir")
    require('fzf-lua').grep_project({ cwd = cwd })
  end)

vim.keymap.set('n', '<leader>b', require('fzf-lua').lsp_workspace_diagnostics)
vim.keymap.set('n', '<leader>y', require('fzf-lua').lsp_document_symbols)
vim.keymap.set('n', '<leader>Y', require('fzf-lua').lsp_workspace_symbols)
vim.keymap.set('n', '<leader>`', require('fzf-lua').lsp_finder)
vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references)
vim.keymap.set('n', 'ga', require('fzf-lua').lsp_code_actions)

-- https://github.com/mattn/emmet-vim
vim.g.user_emmet_leader_key = '<C-Z>'

-- https://github.com/echasnovski/mini.comment
require('mini.comment').setup({
  options = {
    ignore_blank_line = true
  }
})

-- https://github.com/norcalli/nvim-colorizer.lua
require('colorizer').setup()
