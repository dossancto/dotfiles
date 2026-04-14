return {
	{
		"mason-org/mason.nvim",
		opts = {}
	},
	{
		'DestopLine/boilersharp.nvim',
		config = function()
			require('boilersharp').setup()
		end,
		opts = {
			-- Your options go here
		},
	},
	{
		'saghen/blink.cmp',
		event = 'InsertEnter',
		-- use prebuilt binary for fuzzy
		-- version = '1.*',
		-- build = 'cargo build --release',
		opts = {
			keymap = {
				preset = 'none',

				['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },

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
			},
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 400,
					window = { border = 'rounded' },
				},
				list = { selection = { preselect = true, auto_insert = false } },
				menu = { border = 'rounded', draw = { treesitter = { 'lsp' } } },
			},
			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer' },
				providers = {
					lsp = { score_offset = 4 },
					laravel = {
						name = 'laravel',
						module = 'blink.compat.source',
						score_offset = 95, -- show at a higher priority than lsp
					},
					buffer = { score_offset = 2 },
					path = { score_offset = 2 },
					snippets = { score_offset = -2, min_keyword_length = 2 },
				},
			},
			snippets = { preset = 'luasnip' },
			signature = {
				enabled = false,
				window = { show_documentation = false, border = 'rounded' },
			},
			cmdline = { enabled = false },
			fuzzy = {
				implementation = 'lua',
				sorts = {
					'score',
					'sort_text',
				},
			},
		},
		dependencies = {
			'L3MON4D3/LuaSnip',
			{
				'saghen/blink.compat',
				version = '*',
				lazy = true,
			},
			{ 'rafamadriz/friendly-snippets' },
		},
	},
	{
		'L3MON4D3/LuaSnip',
		event = 'VeryLazy',
		version = 'v2.*', -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		build = 'make install_jsregexp',
		config = function()
			require('luasnip.loaders.from_vscode').lazy_load()
		end,
		dependencies = { 'rafamadriz/friendly-snippets' },
	},
	{
		'folke/todo-comments.nvim',
		cmd = { 'TodoTrouble' },
		event = { 'BufReadPost', 'BufNewFile' },
		opts = {},
		dependencies = { 'nvim-lua/plenary.nvim' },
	},
	{
		'hat0uma/csvview.nvim',
		cmd = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle' },
		opts = {
			parser = { comments = { '#', '//' } },
			keymaps = {
				-- Text objects for selecting fields
				textobject_field_inner = { 'if', mode = { 'o', 'x' } },
				textobject_field_outer = { 'af', mode = { 'o', 'x' } },
				-- Excel-like navigation: move with tab and enter
				-- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
				jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
				jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
				jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
				jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
			},
		},
	}
}
