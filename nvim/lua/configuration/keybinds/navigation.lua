local map = vim.keymap.set
local unmap = vim.keymap.del

map('n', 'gvd', function()
	vim.cmd('vsplit')
end, { desc = 'LSP: Go to Definition (vertical split)' })

map('n', 'gvi', function()
	vim.cmd('vsplit')
end, { desc = 'LSP: Go to Implementation (vertical split)' })

map('n', 'gvr', function()
	vim.cmd('vsplit')
end, { desc = 'LSP: Go to References (vertical split)' })

map('n', 'F', "<cmd> lua require('spectre').toggle() <cr>", { desc = 'Open Spectre' })
