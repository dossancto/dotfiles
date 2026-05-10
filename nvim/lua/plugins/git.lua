return {
	{
		'sindrets/diffview.nvim',
		config = function()
			require('diffview').setup({
				view = {
					merge_tool = {
						-- Config for conflicted files in diff views during a merge or rebase.
						layout = 'diff3_mixed',
						disable_diagnostics = true, -- Temporarily disable diagnostics for diff buffers while in the view.
						winbar_info = true, -- See |diffview-config-view.x.winbar_info|
					},
				},
			})
		end,
	},
	{
		'lewis6991/gitsigns.nvim',
		cmd = { 'Gitsigns' },
		lazy = false,
		opts = {},
	},
	{
		"pwntester/octo.nvim",
		cmd = "Octo",
		lazy = false,
		opts = {
			-- or "fzf-lua" or "snacks" or "default"
			picker = "snacks",
			-- bare Octo command opens picker of commands
			enable_builtin = true,
		},
		keys = {
			{
				"<leader>oi",
				"<CMD>Octo issue list<CR>",
				desc = "List GitHub Issues",
			},
			{
				"<leader>op",
				"<CMD>Octo pr list<CR>",
				desc = "List GitHub PullRequests",
			},
			{
				"<leader>od",
				"<CMD>Octo discussion list<CR>",
				desc = "List GitHub Discussions",
			},
			{
				"<leader>on",
				"<CMD>Octo notification list<CR>",
				desc = "List GitHub Notifications",
			},
			{
				"<leader>os",
				function()
					require("octo.utils").create_base_search_command { include_current_repo = true }
				end,
				desc = "Search GitHub",
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"folke/snacks.nvim",
			"nvim-tree/nvim-web-devicons",
		},
	},
}
