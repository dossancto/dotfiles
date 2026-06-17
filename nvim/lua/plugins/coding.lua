return {
	-- {
	-- 	'nvim-treesitter/nvim-treesitter',
	-- 	lazy = false,
	-- 	event = { 'BufReadPost', 'BufNewFile' },
	-- 	opts = {
	-- 		auto_install = true,
	-- 		highlight = {
	-- 			enable = true,
	-- 			additional_vim_regex_highlighting = false,
	-- 		},
	-- 	},
	-- 	build = ':TSUpdate',
	-- 	dependencies = {
	-- 		-- auto load
	-- 		-- 'nvim-treesitter/nvim-treesitter-refactor',
	-- 		'HiPhish/rainbow-delimiters.nvim',
	-- 	},
	-- },
	{
		'echasnovski/mini.pairs',
		event = 'VeryLazy',
		opts = {
			modes = { insert = true, command = false, terminal = false },
		},
	},
	{
		'HiPhish/rainbow-delimiters.nvim',
		lazy = true,
		submodules = false,
		config = function()
			local rainbow = require('rainbow-delimiters')
			require('rainbow-delimiters.setup')({
				strategy = {
					[''] = rainbow.strategy['global'],
					vim = rainbow.strategy['local'],
				},
				query = {
					[''] = 'rainbow-delimiters',
					lua = 'rainbow-blocks',
				},
				highlight = {
					'RainbowDelimiterRed',
					'RainbowDelimiterYellow',
					'RainbowDelimiterBlue',
					'RainbowDelimiterOrange',
					'RainbowDelimiterGreen',
					'RainbowDelimiterViolet',
					'RainbowDelimiterCyan',
				},
			})
		end,
	},
}
