local map = vim.keymap.set
local unmap = vim.keymap.del

local diagnostic_goto = function(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end

map('n', '<leader>lj', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
map('n', '<leader>lk', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })

map('n', '<leader>lw', diagnostic_goto(true, nil), { desc = 'Next Error' })
map('n', '<leader>lq', diagnostic_goto(false, nil), { desc = 'Prev Error' })

map('n', '<leader>[w', diagnostic_goto(true), { desc = 'Next Error' })

map('n', '<leader>]w', diagnostic_goto(false), { desc = 'Prev Error' })

map('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'Actions' })

map('n', '<leader>lr', vim.lsp.buf.rename, { desc = 'Rename Symbol' })

map('n', '<Leader>fm', function()
	vim.lsp.buf.format({ async = true })
end, { desc = 'Format current buffer with LSP' })

map('n', 'gi', function() Snacks.picker.lsp_implementations() end, { desc = 'Goto Implementation' })

-- { "gI",              function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" }
