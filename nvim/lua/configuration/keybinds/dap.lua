local map = vim.keymap.set
local unmap = vim.keymap.del

map('n', '<leader>du', '<cmd>DapViewToggle<cr>', { desc = 'Open DAP' })
map('n', '<leader>da', '<cmd>lua require("nvim-dap-virtual-text").setup()<cr>', { desc = 'Eval' })
