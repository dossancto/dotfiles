local map = vim.keymap.set
local unmap = vim.keymap.del

map('v', '<leader>ii', ":'<,'>CodeCompanion<cr>", { desc = 'Open Companion with selection' })
map('v', '<leader>ia', ":'<,'>CodeCompanion /docs<cr>", { desc = 'Write documentation for the selected code' })
