vim.cmd('colorscheme base16') -- $HOME/.files/.config/nvim/colors/
vim.opt.background = 'light'
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

-- theprimeagen
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set('n', '<cr><cr>', function() vim.cmd('<silent>! TMUX= NO_DIFF=1 source $HOME/.files/.zprofile') end, { noremap = true })
vim.keymap.set('n', '<leader>g', function()
  local filename = string.gsub(vim.fn.expand('%'), os.getenv('PWD') or "", "")
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  vim.cmd('! gh browse ' .. filename .. ':' .. row)
end, { noremap = true, silent = true })

vim.keymap.set('n', '<cr><cr>', function() vim.cmd('wa | silent make | source $MYVIMRC | normal `.') end)
vim.keymap.set('n', '<C-k>', function() vim.cmd('Inspect') end)

vim.diagnostic.config({
  signs = false,
  update_in_insert = false,
  underline = true,
  virtual_text = { severity = vim.diagnostic.severity.ERROR, spacing = 4 }
})

-- TODO: split up lsp into FileType and UserCommand
--- lsp function
--- @param pattern table filetypes
--- @param project_to_lsp table lsp setup
local function lsp(pattern, project_to_lsp)
  -- TODO: fallback pwd
  local git_root_dir = vim.fn.system("git rev-parse --show-toplevel"):gsub('[\n\r]+', '')
  vim.api.nvim_create_autocmd('FileType', {
    pattern = pattern,
    callback = function()
      local cmd
      local root_dir
      for project, lsp_config in pairs(project_to_lsp) do
       if os.execute('test -e ' .. project) == 0 then
          cmd = lsp_config.cmd
          root_dir = vim.fn.getcwd()
          break
        end

       if os.execute('test -e ' .. git_root_dir  .. '/' .. project) == 0 then
          cmd = lsp_config.cmd
          root_dir = git_root_dir
          break
        end
      end

      if cmd == nil then return end
      if vim.fn.executable(cmd[1]) == 0 then return end

      local client = vim.lsp.start({ name = project_file, cmd = cmd, root_dir = root_dir, settings = settings })

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true })
      ---@format disable-next
      vim.keymap.set('n', '<leader>p', function() vim.lsp.buf.format({ async = true }) end, { noremap = true, silent = true })
      vim.keymap.set('n', 'gR', vim.lsp.buf.rename, { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>T', vim.diagnostic.open_float, { noremap = true, silent = true })

      if cmd[1] == 'typescript-language-server'
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
        vim.keymap.set('n', '<leader>p', function() vim.cmd(':PrettierAsync') end, { noremap = true })
        vim.keymap.set('n', '<leader>t', function() vim.cmd('vsplit ' .. filename(false)) end, { noremap = true })
        ---@format disable-next
        vim.keymap.set('n', '<leader>r', function() vim.cmd('! tmux split-window -h "npmw test ' .. filename(true) .. '"') end, { noremap = true })
        ---@format disable-next
        vim.api.nvim_create_user_command("Eslint", function() vim.cmd(":silent make -f .DS_Store eslint-fix | copen") end, {})
      end
    end
  })
end

vim.api.nvim_create_user_command("LspInfo", function() vim.cmd(":lua= vim.lsp.get_active_clients()") end, {})
vim.api.nvim_create_user_command("LspStop", function() vim.cmd(":lua= vim.lsp.stop_client(vim.lsp.get_clients(), { force = true})") end, {})

lsp({ 'go' }, { ['go.mod'] = { cmd = { 'gopls' } } })
lsp({ 'templ' }, { ['go.mod'] = { cmd = { 'templ', 'lsp' } } })

lsp({ 'typescript', 'javascript', 'javascriptreact', 'typescriptreact' }, {
 ['deno.json']     = { cmd = { 'deno', 'lsp' } },
 ['node_modules/.bin/tsserver'] = { cmd = { 'typescript-language-server', '--stdio' } },
})

lsp({ 'rust' }, { ['Cargo.toml'] = { cmd = { 'rust-analyzer' } } })
lsp({ 'terraform' }, { ['.terrform.lock.hcl'] = { cmd = { 'terraform-ls', 'serve' } } })
lsp({ 'gleam' }, { ['gleam.toml'] = { cmd = { 'gleam', 'lsp' } } })

-- https://github.com/ibhagwan/fzf-lua
require('fzf-lua').setup({
  'default',
  winopts = {
    fullscreen = false,
    preview = { layout = 'vertical' }
  }
})

vim.keymap.set('n', '<leader>-', require('fzf-lua').builtin, { noremap = true, silent = true })
vim.keymap.set('n', '<leader><leader>', require('fzf-lua').files, { noremap = true, silent = true })
vim.keymap.set('n', '``', require('fzf-lua').buffers, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>=', require('fzf-lua').grep_project, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>w', require('fzf-lua').grep_cword, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>W', require('fzf-lua').grep_cWORD, { noremap = true, silent = true })
vim.keymap.set('v', '<leader>w', require('fzf-lua').grep_visual, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>/', require('fzf-lua').blines, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>`', require('fzf-lua').git_status, { noremap = true, silent = true })

vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, { noremap = true, silent = true })
vim.keymap.set('n', 'ga', require('fzf-lua').lsp_code_actions, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>b', require('fzf-lua').lsp_workspace_diagnostics, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>y', require('fzf-lua').lsp_document_symbols, { noremap = true, silent = true })

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

-- https://github.com/prettier/vim-prettier

-- https://github.com/echasnovski/mini.completion
require('mini.completion').setup()

-- https://github.com/echasnovski/mini.surround
require('mini.surround').setup()

-- https://github.com/echasnovski/mini.comment
require('mini.comment').setup()
