vim.g.mapleader = " "
vim.cmd("language en_US.utf8")

require("init.lazy_pre").check_load_lazy()
require("init.lsp")
require("configuration.post_options")

require("configuration.options")
require("configuration.keybinds.init")

vim.cmd.colorscheme("gruvbox-material")
