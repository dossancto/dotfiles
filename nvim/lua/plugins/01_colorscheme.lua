return {
	-- colortheme is load right after lazy setup
	{
		"Shatur/neovim-ayu",
		lazy = true,

		opts = {
   		    mirage = false, -- Set to `true` to use `mirage` variant instead of `dark` for dark background.
			terminal = false, -- Set to `false` to let terminal manage its own colors.
			overrides = {}, -- A dictionary of group names, each associated with a di		}
		}
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
