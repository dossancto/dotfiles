return {
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({})
		end,
	},

	{
		"github/copilot.vim",
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",

		},
		opts = {
			interactions = {
				inline = {
					adapter = {
						name = "copilot",
						model = "gpt-6-luna",
					},
				},
			},
		},
		keys = {
			{ "<leader>ai", ":'<,'>CodeCompanion<CR>", mode = "v", desc = "Inline AI Edit" },
		},
	}
}
