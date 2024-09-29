--   base00: "#0c0d0e" #  ----
--   base01: "#2e2f30" #  ---
--   base02: "#515253" #  --
--   base03: "#737475" #  -
--   base04: "#959697" #  +
--   base05: "#b7b8b9" #  ++
--   base06: "#dadbdc" #  +++
--   base07: "#fcfdfe" #  ++++

--   base08: "#e31a1c" #	red
--   base09: "#e6550d" #	orange
--   base0A: "#dca060" #	yellow
--   base0B: "#31a354" #	green
--   base0C: "#80b1d3" #	aqua
--   base0D: "#3182bd" #	blue
--   base0E: "#756bb1" #	purple
--   base0F: "#b15928" #	brown

vim.g.colors_name = 'zzz'
vim.cmd('runtime colors/quiet.vim')
vim.opt.background = '{{variant}}'

vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NonText', { bg = 'none' })
vim.api.nvim_set_hl(0, 'MatchParen', { fg = '#{{base09-hex}}' })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#{{base01-hex}}' })
vim.api.nvim_set_hl(0, 'Statement', { fg = '#{{base07-hex}}', bold = true })
vim.api.nvim_set_hl(0, 'Keyword', { fg = '#{{base05-hex}}', bold = true })
