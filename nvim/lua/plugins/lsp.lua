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
	},


	-- lspconfig
	{
		'neovim/nvim-lspconfig',
		event = { 'BufReadPre', 'BufNewFile' },
		opts = {
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = { spacing = 4, prefix = '●' },
				severity_sort = true,
			},
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { 'vim' },
							},
						},
					},
				},
				clangd = {
					filetypes = { 'c', 'cpp' },
				},
				biome = { -- https://biomejs.dev/guides/integrate-in-editor/
					workspace_required = false,
				},
			},
		},
		config = function(_, opts)
			-- diagnostic
			vim.diagnostic.config(opts.diagnostics)

			-- apply customized lsp config
			for server, conf in pairs(opts.servers) do
				vim.lsp.config(server, conf)
			end
		end,
		dependencies = {
			-- lsp server setup
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',

			-- lsp completion
			'saghen/blink.cmp',
		},
	},

	-- easy lspconfig: implicitly load mason and auto install lsp servers
	{
		'williamboman/mason-lspconfig.nvim',
		lazy = true,
		opts = {
			automatic_installation = false,
		},
		dependencies = {
			'williamboman/mason.nvim',
			-- 'neovim/nvim-lspconfig',
		},
	},

	-- manage LSP servers, DAP servers, linters, and formatters
	{
		'williamboman/mason.nvim',
		cmd = 'Mason',
		build = ':MasonUpdate',
		opts = { -- required for :Mason
			-- log_level = vim.log.levels.OFF,
			registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
			},
			max_concurrent_installers = 4,
			ui = {
				-- disable check on :Mason window
				check_outdated_packages_on_open = false,

				border = 'rounded',
				width = 0.8,
				height = 0.8,
			},
		},
	},

	-- lightweight yet powerful formatter
	{
		'stevearc/conform.nvim',
		lazy = true,
		opts = function()
			return vim.tbl_deep_extend('keep',
				{
					-- format only the listed ft
					formatters_by_ft = {
						zig = { 'zigfmt' },
						python = { 'ruff_format' },
						rust = { 'rustfmt' },
						vala = { 'uncrustify' },
						lua = { 'stylua' },
						sh = { 'shfmt' },

						d2 = { 'd2' },
						proto = { 'buf' },
						json = { 'biome' },
						jsonc = { 'biome' },
						css = { 'biome' },
					},

					-- customize formatters
					formatters = {
						uncrustify = {
							env = { UNCRUSTIFY_CONFIG = '.uncrustify.cfg' },
						},
					},

					default_format_opts = {
						lsp_format = 'fallback',
						quiet = true,

						-- nvim lsp
						async = true, -- edit during format can lead to unexpected changes for lsp format
						timeout_ms = 2000, -- ignored if async=true
					},

					-- format_on_save = { timeout_ms = 500, lsp_fallback = true },
				},
				{
					notify_on_error = true,
					-- log_level = vim.log.levels.OFF,
				})
		end,
	},

	-- asynchronous linter, beyond lsp
	{
		'mfussenegger/nvim-lint',
		event = { 'BufReadPre', 'BufNewFile' },
		opts = function()
			return vim.tbl_deep_extend('keep', {
				-- lint only the listed ft
				linters_by_ft = {
					python = { 'ruff' },
				},

				-- customize linters
				linters = {},
			}, {
				-- some linters may rely on files to be saved
				trigger_on_events = {
					'BufWritePost',
					'BufReadPost',
					'InsertLeave',
					'TextChanged',
				},
			})
		end,
		config = function(_, opts)
			local lint = require('lint')

			-- bind linters
			for name, linter in pairs(opts.linters) do
				if type(linter) == 'table' and type(lint.linters[name]) == 'table' then
					lint.linters[name] =
					    vim.tbl_deep_extend('force', lint.linters[name], linter)
				else
					lint.linters[name] = linter
				end
			end

			lint.linters_by_ft = opts.linters_by_ft

			-- trigger lint
			vim.api.nvim_create_autocmd(opts.trigger_on_events, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
