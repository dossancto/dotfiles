vim.g.mapleader = " "
vim.cmd("language en_US.utf8")

require("configuration.options")
require("configuration.keybinds.init")

require("init.lazy_pre").check_load_lazy()
vim.cmd("colorscheme melange")
require("init.lsp")
