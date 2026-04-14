vim.g.mapleader = " "
vim.cmd("language en_US.utf8")

require("configuration.options")
require("configuration.keybinds.init")

require("init.lazy_pre").check_load_lazy()

vim.api.nvim_create_autocmd('FileType', {
  pattern = { '<filetype>' },
  callback = function() vim.treesitter.start() end,
})

vim.cmd("colorscheme gruvbox-material")
