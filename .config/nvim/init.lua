vim.cmd('colorscheme base16') -- $HOME/.files/.config/nvim/colors/
vim.opt.background = '{{variant}}'
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
vim.opt.rnu = false
vim.opt.list = true
vim.opt.listchars = "tab:  ,trail:·,eol: ,nbsp:_"
vim.opt.cmdheight = 1
vim.opt.cursorline = true
vim.opt.undofile = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

vim.keymap.set('n', '<cr><cr>', function() vim.cmd('<silent>! TMUX= NO_DIFF=1 source $HOME/.files/.zprofile') end, { noremap = true })
vim.keymap.set('n', '<leader>g', function()
  local filename = string.gsub(vim.fn.expand('%'), os.getenv('PWD') or "", "")
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.cmd("! gh browse '" .. filename .. "':" .. row)
end, { noremap = true, silent = true })

vim.keymap.set('n', '<cr><cr>', function() vim.cmd('wa | silent make | source $MYVIMRC | normal `.') end)
vim.keymap.set('n', '<C-k>', function() vim.cmd('Inspect') end)

vim.diagnostic.config({
  signs = false,
  update_in_insert = false,
  underline = true,
  virtual_text = { severity = vim.diagnostic.severity.ERROR, spacing = 4 }
})

vim.lsp.set_log_level("DEBUG")

vim.api.nvim_create_user_command("LspInfo", function() vim.cmd(":lua= vim.lsp.get_active_clients()") end, {})
vim.api.nvim_create_user_command("LspStop", function() vim.lsp.stop_client(vim.lsp.get_clients(), { force = true}) end, {})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })
    vim.keymap.set('n', '<leader>p', function() vim.lsp.buf.format({ async = true }) end, { buffer = args.buf })
    vim.keymap.set('n', 'gR', vim.lsp.buf.rename, { buffer = args.buf })
    vim.keymap.set('n', '<leader>T', vim.diagnostic.open_float, { buffer = args.buf })

    if client.config.cmd[1] == 'typescript-language-server'
    then
      local function filename(test)
        local buffer = vim.fn.expand('%')
        if buffer:sub(-string.len('test.ts')) == 'test.ts' then
          if test == true then
            return buffer
          else
            return string.gsub(buffer, ".test.ts$", ".ts")
          end
        end
        return string.gsub(buffer, ".ts$", ".test.ts")
      end

      pcall(vim.keymap.del, 'n', '<leader>p')
      vim.keymap.set('n', '<leader>p', function() vim.cmd('! gfmt') end, { buffer = args.buf })
      vim.keymap.set('n', '<leader>t', function() vim.cmd('vsplit ' .. filename(false)) end, { buffer = args.buf })
      vim.keymap.set('n', '<leader>r', function() vim.cmd('! tmux split-window -h "npmw test ' .. filename(true) .. '"') end, { buffer = args.buf })
      vim.keymap.set('n', '<leader>B', function() vim.cmd('! tmux split-window -h "git blame % | vipe -"') end, { buffer = args.buf })
    end

  end,
})


local function root_dir(file)
  if os.execute('test -e ' .. file) == 0
  then
    return vim.fn.getcwd()
  end

  local git_root_dir = vim.fn.system("git rev-parse --show-toplevel"):gsub('[\n\r]+', '')
  if os.execute('test -e ' .. git_root_dir ..  '/' .. file) == 0
  then
    return git_root_dir
  end

  return nil
end

local function vim_lsp_start(file, cmd, settings)
  local root_dir = root_dir(file)
  if root_dir == nil then return end

  vim.lsp.start({
    cmd = cmd,
    settings = settings,
    name = cmd[1],
    root_dir = root_dir,
  })
end

vim.api.nvim_create_autocmd('FileType', { pattern = {'go'},                            callback = function() vim_lsp_start('go.mod',             {'gpls'}) end })
vim.api.nvim_create_autocmd('FileType', { pattern = {'terraform'},                     callback = function() vim_lsp_start('.terrform.lock.hcl', {'terraform-ls', 'serve'}) end })
vim.api.nvim_create_autocmd('FileType', { pattern = {'typescript', 'typescriptreact', 'javascript', 'javascriptreact'}, 
  callback = function() 
    vim_lsp_start('deno.json', {'deno', 'lsp'}) 
    vim_lsp_start('node_modules/.bin/tsserver', {'typescript-language-server', '--stdio'})
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

vim.keymap.set('n', '<leader>-', require('fzf-lua').builtin, { noremap = true, silent = true })
vim.keymap.set('n', '<leader><leader>', function() require('fzf-lua').files({resume=true}) end, { noremap = true, silent = true })
vim.keymap.set('n', '``', require('fzf-lua').buffers, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>=', require('fzf-lua').grep_project, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>w', require('fzf-lua').grep_cword, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>W', require('fzf-lua').grep_cWORD, { noremap = true, silent = true })
vim.keymap.set('v', '<leader>w', require('fzf-lua').grep_visual, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>/', require('fzf-lua').blines, { noremap = true, silent = true })

vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, { noremap = true, silent = true })
vim.keymap.set('n', 'ga', require('fzf-lua').lsp_code_actions, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>b', require('fzf-lua').lsp_workspace_diagnostics, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>y', require('fzf-lua').lsp_document_symbols, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>Y', require('fzf-lua').lsp_workspace_symbols, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>`', require('fzf-lua').lsp_finder, { noremap = true, silent = true })

-- https://github.com/nvim-treesitter/nvim-treesitter
require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  }
})
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'

-- https://github.com/mattn/emmet-vim
vim.g.user_emmet_leader_key = '<C-Z>'

-- https://github.com/echasnovski/mini.completion
require('mini.completion').setup()

-- https://github.com/echasnovski/mini.comment
require('mini.comment').setup()
