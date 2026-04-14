local map = vim.keymap.set
local unmap = vim.keymap.del

map('n', '<Leader>gk', '<cmd>Gitsigns prev_hunk<cr>')
map('n', '<Leader>gj', '<cmd>Gitsigns next_hunk<cr>')

map('n', '<Leader>gm', '<cmd>DiffviewOpen<cr>')

map('n', '<Leader>gC', '<cmd>DiffviewClose<cr>')

map('n', '<Leader>gr', '<cmd>Gitsigns reset_hunk<cr>')
