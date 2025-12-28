local M = {}
local map = vim.keymap.set
local unmap = vim.keymap.del
local util = require('init.utils')

local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

-- IA section
map({"n", "v"}, "<leader>aa", "<cmd>CodeCompanion<cr>", { desc = "Open Companion" })
map({"n", "v"}, "<leader>at", "<cmd>CodeCompanionChat toggle<cr>", { desc = "Open Companion" })
map("n", "<leader>ac", "<cmd>CodeCompanionActions<cr>", { desc = "Open Companion Help" })

map("n", ";", ":", { desc = "CMD enter command mode" })

map({'n', 'i', 'v'}, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })

map('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- Resize with arrows
map('n', '<C-Up>', ':resize +2<CR>', { silent = true })
map('n', '<C-Down>', ':resize -2<CR>', { silent = true })
map('n', '<C-Left>', ':vertical resize -2<CR>', { silent = true })
map('n', '<C-Right>', ':vertical resize +2<CR>', { silent = true })

-- Git
map("n", "<Leader>gk", "<cmd>Gitsigns prev_hunk<cr>")
map("n", "<Leader>gj", "<cmd>Gitsigns next_hunk<cr>")
map("n", "<Leader>gm", "<cmd>DiffviewOpen<cr>")
map("n", "<Leader>gC", "<cmd>DiffviewClose<cr>")
map("n", "<Leader>gh", "<cmd>DiffviewFileHistory %<cr>")
map("n", "<Leader>ge", "<cmd>DiffviewToggleFiles<cr>")
map("n", "<Leader>gn", "<cmd>GitBlameCopyCommitURL<cr>")
map("n", "<Leader>gr", "<cmd>Gitsigns reset_hunk<cr>")
map("n", "<Leader>gg", "<cmd>Gitui<cr>")

map("n", "<leader>lj", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "<leader>lk", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
-- map("n", "<leader>lj", diagnostic_goto(true), { desc = "Next Diagnostic" })
-- map("n", "<leader>lk", diagnostic_goto(false), { desc = "Prev Diagnostic" })



map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Actions" })
map("n", "F", "<cmd> lua require('spectre').toggle() <cr>", { desc = "Open Spectre" })
map("n", "<leader>F", "<cmd>Spectre<cr>", { desc = "Open Spectre" })

map('n', '<Leader>fm', function()
    vim.lsp.buf.format { async = true }
end, { desc = 'Format current buffer with LSP' })

-- keymaps generic

M.basic = {
	{ '<F1>', '<nop>', mode = { 'n', 'i', 'v' }, desc = 'unbind :help' },

	{ '<esc><esc>', '<c-\\><c-n>', mode = 't', desc = 'Normal Mode' },

	{ '<C-t>', util.float_term, desc = 'Float Terminal' },

	{ '<S-F1>', util.toggle_mouse, desc = 'Toggle Mouse' },
	{ '<S-F2>', util.toggle_number, desc = 'Toggle Number' },
	{ '<S-F3>', util.toggle_listchars, desc = 'Toggle ListChars' },
	{ '<S-F4>', util.toggle_diagnostic, desc = 'Toggle Diagnostic' },
	-- for compatability: `S-F2` == `F14` and etc.
	{ '<F13>', util.toggle_mouse, desc = 'Toggle Mouse' },
	{ '<F14>', util.toggle_number, desc = 'Toggle Number' },
	{ '<F15>', util.toggle_listchars, desc = 'Toggle ListChars' },
	{ '<F16>', util.toggle_diagnostic, desc = 'Toggle Diagnostic' },
}

-- keymaps for plugins

M.trim = { { '<C-1>', ':Trim<cr>', desc = 'Trim Space' } }

M.snacks = function()
	local S = {}
	setmetatable(S, {
		__index = function(_, k)
			if k == 'explorer' then
				return function(...)
					return require('snacks').explorer(...)
				end
			end
			return setmetatable({}, {
				__index = function(_, sub_k)
					return function(...)
						return require('snacks')[k][sub_k](...)
					end
				end,
			})
		end,
	})

	return {
		{ '<F1>', S.explorer, desc = 'file explorer' },
		{ '<C-2>', S.notifier.hide, desc = 'hide notifier' },

		{ '<Leader>fb', S.picker.buffers, desc = 'find buffers' },
		{ '<Leader>ff', S.picker.files, desc = 'find files' },
		{ '<Leader>fg', S.picker.grep, desc = 'text grep' },
		{ '<Leader>fh', S.picker.help, desc = 'help pages' },
		{ "gs", function() S.picker.lsp_symbols() end, desc = "LSP Symbols" },

		{ "<leader>go", function() S.picker.git_status() end, desc = "Find Git Files" },


		{ '<Leader>sj', S.picker.jumps, desc = 'Jumps' },
		{ '<Leader>sk', S.picker.keymaps, desc = 'Keymaps' },
		{ '<Leader>sl', S.picker.loclist, desc = 'Location List' },
		{ '<Leader>sq', S.picker.qflist, desc = 'Quickfix List' },
		{ '<Leader>sm', S.picker.marks, desc = 'Marks' },

		{ '<Leader>sD', S.picker.diagnostics, desc = 'diagnostics global' },
		{ '<Leader>sd', S.picker.diagnostics_buffer, desc = 'diagnostics' },
		{ '<Leader>ss', S.picker.lsp_symbols, desc = 'symbols' },
		{ '<Leader>sS', S.picker.lsp_workspace_symbols, desc = 'symbols global' },
		{ '<Leader>st', S.picker.todo_comments, desc = 'todo' },

		{ 'gd', S.picker.lsp_definitions, desc = 'Goto Definition' },
		{ 'gD', S.picker.lsp_declarations, desc = 'Goto Declaration' },
		{ 'gr', S.picker.lsp_references, nowait = true, desc = 'References' },
		{ 'gi', S.picker.lsp_implementations, desc = 'Goto Implementation' },
		{ 'gy', S.picker.lsp_type_definitions, desc = 'Goto Type Definition' },
	}
end

M.trouble = {
	{ '<F3>', ':Trouble symbols toggle<cr>', desc = 'toggle symbols' },
	{ '<F4>', ':Trouble diagnostics toggle<cr>', desc = 'toggle diagnostics' },
}

-- stylua: ignore
M.persistence = {
	{ '<Leader>Ss', function() require('persistence').save() end, desc = 'Save Session' },
	{ '<Leader>Sl', function() require('persistence').load() end, desc = 'Load Session' },
}

M.cmp = {
	preset = 'none',

	['<CR>'] = { 'accept', 'fallback' },
	['<C-Tab>'] = { 'show', 'show_documentation', 'hide_documentation' },

	['<Tab>'] = { 'select_next', 'fallback' },
	['<S-Tab>'] = { 'select_prev', 'fallback' },

	['<C-e>'] = { 'hide' },
	['<C-y>'] = { 'select_and_accept' },

	['<Up>'] = { 'select_prev', 'fallback' },
	['<Down>'] = { 'select_next', 'fallback' },
	['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
	['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
}

M.lsp = {
	{ 'K', vim.lsp.buf.hover, desc = 'Hover' },

	{ '<C-d>', vim.diagnostic.open_float, desc = 'Line Diagnostics' },
	{ '<C-k>', vim.lsp.buf.signature_help, mode = '', desc = 'Signature Help' },
	{ '<C-a>', vim.lsp.buf.code_action, mode = { 'n', 'v' }, desc = 'Code Action' },

	{ '<C-f>', util.format, desc = 'Format' },

	{ '<Leader>cl', ':LspInfo<cr>', desc = 'Lsp Info' },
}

-- stylua: ignore
M.dap = {
		-- use `dc` to start/continue, ref: `:help dap-api`
	{ '<Leader>dc', function() require('dap').continue() end, desc = 'Start/Continue' },
	{ '<Leader>dt', function() require('dap').terminate() end, desc = 'Terminate' },
	{ '<Leader>dp', function() require('dap').pause() end, desc = 'Pause' },

	{ '<Leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle Breakpoint' },
	{ '<Leader>dL', function() require('dap').list_breakpoints() end, desc = 'List Breakpoint' },

	-- REPL window also provide control with interactive commands or mouse
	{ '<Leader>dn', function() require('dap').step_over() end, desc = 'Step Over' },
	{ '<Leader>di', function() require('dap').step_into() end, desc = 'Step Into' },
	{ '<Leader>do', function() require('dap').step_out() end, desc = 'Step Out' },

	{ '<Leader>dk', function() require('dap').up() end, desc = 'Up in Stacktrace' },
	{ '<Leader>dj', function() require('dap').down() end, desc = 'Down in Stacktrace' },

	-- REPL: provide command line input/output, better to work with mouse or dap-ui
	{ '<Leader>dr', function() require('dap').repl.toggle() end, desc = 'Toggle REPL' },
}

-- stylua: ignore
M.dapui = {
	{ '<Leader>du', function() require('dapui').toggle() end, desc = 'DapUI toggle' },
	{ '<Leader>de', function() require('dapui').eval() end, desc = 'DapUI eval' },
}

-- mini.comment: internal map in opts
M.mini_comment = {
	-- Use `''` (empty string) to disable one.

	comment = '', -- Toggle comment for both Normal and Visual modes
	comment_line = 'cc', -- Toggle comment on current line
	comment_visual = 'cc', -- Toggle comment on visual selection

	-- Define 'comment' textobject (like `dgc` - delete whole comment block)
	textobject = '',
}

-- ts-refactor: internal map
M.ts_refactor = {
	rename = { smart_rename = 'gR' },
	navigate = {
		goto_definition = 'gd',
		list_definitions = 'gl',
		list_definitions_toc = 'gL',
		goto_next_usage = false,
		goto_previous_usage = false,
	},
}

function M.load_keymaps()
	for _, km in ipairs(M.basic) do
		local mode = km.mode or { 'n', 'v', 'o' }
		map(mode, km[1], km[2], { desc = km.desc })
	end
end

return M
