return {
	-- C#
	{
		'seblyng/roslyn.nvim',
		---@module 'roslyn.config'
		---@type RoslynNvimConfig
		ft = { 'cs', 'razor' },
		opts = {
			-- your configuration comes here; leave empty for default settings
		},

		dependencies = {
			{
				-- By loading as a dependencies, we ensure that we are available to set
				-- the handlers for Roslyn.
				'tris203/rzls.nvim',
				config = true,
			},
		},

		config = function()
			local rzls_path = vim.fn.expand('$MASON/packages/rzls/libexec')
			local cmd = {
				'roslyn',
				'--stdio',
				'--logLevel=Information',
				'--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
				'--razorSourceGenerator=' .. vim.fs.joinpath(
					rzls_path,
					'Microsoft.CodeAnalysis.Razor.Compiler.dll'
				),
				'--razorDesignTimePath=' .. vim.fs.joinpath(
					rzls_path,
					'Targets',
					'Microsoft.NET.Sdk.Razor.DesignTime.targets'
				),
				'--extension',
				vim.fs.joinpath(
					rzls_path,
					'RazorExtension',
					'Microsoft.VisualStudioCode.RazorExtension.dll'
				),
			}

			vim.lsp.config('roslyn', {
				cmd = cmd,
				handlers = require('rzls.roslyn_handlers').handlers
					or require('rzls.roslyn_handlers'),
				settings = {
					['csharp|inlay_hints'] = {
						csharp_enable_inlay_hints_for_implicit_object_creation = true,
						csharp_enable_inlay_hints_for_implicit_variable_types = true,

						csharp_enable_inlay_hints_for_lambda_parameter_types = true,
						csharp_enable_inlay_hints_for_types = true,
						dotnet_enable_inlay_hints_for_indexer_parameters = true,
						dotnet_enable_inlay_hints_for_literal_parameters = true,
						dotnet_enable_inlay_hints_for_object_creation_parameters = true,
						dotnet_enable_inlay_hints_for_other_parameters = true,
						dotnet_enable_inlay_hints_for_parameters = true,
						dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
					},
					['csharp|code_lens'] = {
						dotnet_enable_references_code_lens = true,
						dotnet_enable_tests_code_lens = true,
					},
				},
			})

			vim.lsp.enable('roslyn')
		end,
		init = function()
			-- We add the Razor file types before the plugin loads.
			vim.filetype.add({
				extension = {
					razor = 'razor',
					cshtml = 'razor',
				},
			})
		end,
	},
	{
		'nvim-flutter/flutter-tools.nvim',
		lazy = false,
		dependencies = {
			'nvim-lua/plenary.nvim',
			'stevearc/dressing.nvim', -- optional for vim.ui.select
		},
		config = true,
	},

	-- {
	-- 	'gbprod/phpactor.nvim',
	-- 	ft = 'php',
	-- 	dependencies = {
	-- 		'nvim-lua/plenary.nvim',
	-- 		-- If the update/install notification doesn't show properly,
	-- 		-- you should also add here UI plugins like "folke/noice.nvim" or "stevearc/dressing.nvim"
	-- 	},
	-- 	opts = {
	-- 		-- you're options goes here
	-- 	},
	-- },
	{
		'adalessa/laravel.nvim',
		dependencies = {
			'MunifTanjim/nui.nvim',
			'nvim-lua/plenary.nvim',
			'nvim-neotest/nvim-nio',
		},
		ft = { 'php', 'blade' },
		event = {
			'BufEnter composer.json',
		},
		cmd = { 'Laravel' },
		keys = {
			-- {
			-- 	'<leader>ll',
			-- 	function()
			-- 		Laravel.pickers.laravel()
			-- 	end,
			-- 	desc = 'Laravel: Open Laravel Picker',
			-- },
			-- {
			-- 	'<c-g>',
			-- 	function()
			-- 		Laravel.commands.run('view:finder')
			-- 	end,
			-- 	desc = 'Laravel: Open View Finder',
			-- },
			-- {
			-- 	'<leader>la',
			-- 	function()
			-- 		Laravel.pickers.artisan()
			-- 	end,
			-- 	desc = 'Laravel: Open Artisan Picker',
			-- },
			-- {
			-- 	'<leader>lt',
			-- 	function()
			-- 		Laravel.commands.run('actions')
			-- 	end,
			-- 	desc = 'Laravel: Open Actions Picker',
			-- },
			-- {
			-- 	'<leader>lr',
			-- 	function()
			-- 		Laravel.pickers.routes()
			-- 	end,
			-- 	desc = 'Laravel: Open Routes Picker',
			-- },
			-- {
			-- 	'<leader>lh',
			-- 	function()
			-- 		Laravel.run('artisan docs')
			-- 	end,
			-- 	desc = 'Laravel: Open Documentation',
			-- },
			-- {
			-- 	'<leader>lm',
			-- 	function()
			-- 		Laravel.pickers.make()
			-- 	end,
			-- 	desc = 'Laravel: Open Make Picker',
			-- },
			-- {
			-- 	'<leader>lc',
			-- 	function()
			-- 		Laravel.pickers.commands()
			-- 	end,
			-- 	desc = 'Laravel: Open Commands Picker',
			-- },
			-- {
			-- 	'<leader>lo',
			-- 	function()
			-- 		Laravel.pickers.resources()
			-- 	end,
			-- 	desc = 'Laravel: Open Resources Picker',
			-- },
			-- {
			-- 	'<leader>lp',
			-- 	function()
			-- 		Laravel.commands.run('command_center')
			-- 	end,
			-- 	desc = 'Laravel: Open Command Center',
			-- },
			-- {
			-- 	'<leader>lu',
			-- 	function()
			-- 		Laravel.commands.run('hub')
			-- 	end,
			-- 	desc = 'Laravel Artisan hub',
			-- },
			-- {
			-- 	'gf',
			-- 	function()
			-- 		local ok, res = pcall(function()
			-- 			if Laravel.app('gf').cursorOnResource() then
			-- 				return "<cmd>lua Laravel.commands.run('gf')<cr>"
			-- 			end
			-- 		end)
			-- 		if not ok or not res then
			-- 			return 'gf'
			-- 		end
			-- 		return res
			-- 	end,
			-- 	expr = true,
			-- 	noremap = true,
			-- },
		},
		opts = {
			features = {
				pickers = {
					provider = 'snacks', -- "snacks | telescope | fzf-lua | ui-select"
				},
			},
		},
	},
}
