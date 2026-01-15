vim.g.mapleader = " "

-- basic setup
require('init.options').load_options()
require('init.keymaps').load_keymaps()

-- load lazy and the plugins
require('init.lazy_pre').check_load_lazy()

-- vim.cmd("colorscheme ayu-dark")

require('init.lsp')


