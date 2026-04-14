local map = vim.keymap.set
local unmap = vim.keymap.del

map({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })
map({ 'n', 'v' }, ';', ':', { noremap = true, silent = false })

map('n', '<Leader>bo', ":%bd|e#|bd#<CR>", { desc = 'Close other buffers' })
