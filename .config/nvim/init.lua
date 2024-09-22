vim.api.nvim_command('syntax off')
vim.api.nvim_command('colorscheme quiet')
vim.api.nvim_command("hi Normal guibg=none ctermbg=none")
vim.api.nvim_command("hi NonText guibg=none ctermbg=none")
vim.opt.background = '{{variant}}'
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

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
    vim.lsp.set_log_level("DEBUG")
    vim.diagnostic.config({
      update_in_insert = false,
      signs = false,
      underline = true,
      virtual_text = { severity = vim.diagnostic.severity.ERROR, spacing = 4 },
      severity_sort = true,
    })

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then return end

    vim.api.nvim_create_user_command("LspInfo", function() print(vim.inspect(client)) end, {})
    vim.api.nvim_create_user_command("LspStop", function() client.stop() end, {})

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

    -- TODO: omnifunc lsp complete
    -- if client.supports_method('textDocument/completion') then
    --   vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
    -- end

    print('[LspAttach]:' .. vim.inspect(client.config.cmd))
  end,
})


local function get_root_dir(file)
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
  local root_dir = get_root_dir(file)
  if root_dir == nil then return end

  vim.lsp.start({
    cmd = cmd,
    settings = settings,
    name = cmd[1],
    root_dir = root_dir,
  })
end

vim.api.nvim_create_autocmd('FileType', { pattern = {'typescript', 'typescriptreact', 'javascript', 'javascriptreact'},
  callback = function()
    vim_lsp_start('deno.json', {'deno', 'lsp'})
    vim_lsp_start('node_modules/.bin/tsserver', {'typescript-language-server', '--stdio'})
  end
})

vim.api.nvim_create_autocmd('FileType', { pattern = {'go'},
  callback = function()
    vim_lsp_start('go.mod',{'gopls'})
    vim_lsp_start('go.work',{'gopls'})
  end
})

vim.api.nvim_create_autocmd('FileType', { pattern = {'terraform'},
  callback = function()
    vim_lsp_start('.terrform.lock.hcl', {'terraform-ls', 'serve'})
  end
})

vim.api.nvim_create_autocmd('FileType', { pattern = {'rust'},
  callback = function()
    vim_lsp_start('Cargo.toml', {'rust-analyzer'})
  end
})

vim.api.nvim_create_autocmd('FileType', { pattern = {'lua'},
  callback = function()
    local cmd = {'lua-language-server'}
    vim.lsp.start({
      cmd = cmd,
      name = cmd[1],
      root_dir = vim.fn.getcwd(),
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT'
          },
          diagnostics = {
            globals = { 'vim' }
          },
          workspace = {
            library = {
              vim.env.VIMRUNTIME
            },
            checkThirdParty = false
          }
        }
      }
    })
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
vim.keymap.set('n', '<leader><leader>', function() require('fzf-lua').files({resume=false}) end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>[', function() require('fzf-lua').files({resume=true}) end, { noremap = true, silent = true })
vim.keymap.set('n', '``', require('fzf-lua').buffers, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>=', require('fzf-lua').grep_project, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>w', require('fzf-lua').grep_cword, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>W', require('fzf-lua').grep_cWORD, { noremap = true, silent = true })
vim.keymap.set('v', '<leader>w', require('fzf-lua').grep_visual, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>/', require('fzf-lua').blines, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>0', require('fzf-lua').resume, { noremap = true, silent = true })

vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, { noremap = true, silent = true })
vim.keymap.set('n', 'ga', require('fzf-lua').lsp_code_actions, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>b', require('fzf-lua').lsp_workspace_diagnostics, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>y', require('fzf-lua').lsp_document_symbols, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>Y', require('fzf-lua').lsp_workspace_symbols, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>`', require('fzf-lua').lsp_finder, { noremap = true, silent = true })

-- https://github.com/mattn/emmet-vim
vim.g.user_emmet_leader_key = '<C-Z>'

-- https://github.com/echasnovski/mini.comment
require('mini.comment').setup({
  options = {
    ignore_blank_line = true
  }
})
