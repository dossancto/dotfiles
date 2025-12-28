return {
	-- colortheme is load right after lazy setup
	{
		"Shatur/neovim-ayu",
		lazy = true,
	},
	{
		"rebelot/kanagawa.nvim"
	},
	{
	  "vague-theme/vague.nvim",
	  lazy = false, -- make sure we load this during startup if it is your main colorscheme
	  priority = 1000, -- make sure to load this before all the other plugins
	  config = function()
		-- NOTE: you do not need to call setup if you don't want to.
		require("vague").setup({
		  -- optional configuration here
		})
		vim.cmd("colorscheme vague")
	  end
	},
	{
		'sainnhe/gruvbox-material',
  priority = 0, config = true, lazy = false
	},
	-- tokyonight
	{
		'folke/tokyonight.nvim',

		lazy = true,
		priority = 0,

		opts = {
			style = 'night',
			transparent = true,
			on_colors = function(colors)
				colors.bg_highlight = '#161728'
			end,
		},
	},
}
