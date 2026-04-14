return {

	{
		'MattesGroeger/vim-bookmarks',
		config = function()
			-- Configure vim-bookmarks here. For example, to change the bookmark sign to a different character:
			vim.g.bookmark_sign = '' -- Using a Nerd Font icon, for example
			vim.g.bookmark_highlight_group = 'Comment' -- Change the highlight group

			vim.g.bookmark_auto_save = 1
			vim.g.bookmark_save_per_working_dir = 1

			-- You can add other configurations as well.
		end,
	},

	{
		"nvim-pack/nvim-spectre",
		event = "BufRead",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("spectre").setup()
		end,
	},
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
			"TmuxNavigatorProcessList",
		},
		keys = {
			{ "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
	{
		"ibhagwan/fzf-lua",
		keys = {
			{ "<leader>/", false },
		},
	},
}
