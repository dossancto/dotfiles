vim.g.mapleader = " "
vim.cmd("language en_US.utf8")

require("configuration.options")
require("configuration.keybinds.init")

require("init.lazy_pre").check_load_lazy()
vim.cmd.colorscheme("nordic")
require("init.lsp")
require("configuration.post_options")

vim.cmd('set guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"')
