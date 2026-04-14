local map = vim.keymap.set
local unmap = vim.keymap.del

map('n', '<C-Up>', ':resize +2<CR>', { silent = true })
map('n', '<C-Down>', ':resize -2<CR>', { silent = true })
map('n', '<C-Left>', ':vertical resize -2<CR>', { silent = true })
map('n', '<C-Right>', ':vertical resize +2<CR>', { silent = true })
