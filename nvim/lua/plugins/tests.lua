return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			'V13Axel/neotest-pest',
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter"
		},
		config = function()
			require('neotest').setup({
				adapters = {
					require('neotest-pest'),
				}
			})
		end
	}
}
