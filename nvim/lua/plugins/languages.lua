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
			-- {
			-- 	-- By loading as a dependencies, we ensure that we are available to set
			-- 	-- the handlers for Roslyn.
			-- 	'tris203/rzls.nvim',
			-- 	config = true,
			-- },
		},

		extensions = {
			razor = {
				enabled = true,
				config = function()
					local razor_extension_path = require("roslyn.utils").find_razor_extension_path()
					if razor_extension_path == nil then
						return {
							path = nil,
						}
					end

					return {
						path = vim.fs.joinpath(razor_extension_path,
							"Microsoft.VisualStudioCode.RazorExtension.dll"),
						exe = "roslyn-language-server", 
						args = {
							"--razorSourceGenerator="
							.. vim.fs.joinpath(razor_extension_path,
								"Microsoft.CodeAnalysis.Razor.Compiler.dll"),
							"--razorDesignTimePath=" .. vim.fs.joinpath(
								razor_extension_path,
								"Targets",
								"Microsoft.NET.Sdk.Razor.DesignTime.targets"
							),
						},
					}
				end,
			},
		},

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
		dependencies = {
			'nvim-lua/plenary.nvim',
			'stevearc/dressing.nvim', -- optional for vim.ui.select
		},
		config = true,
	},

	{
		"adalessa/laravel.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-neotest/nvim-nio",
		},
		ft = { "php", "blade" },
		event = {
			"BufEnter composer.json",
		},
		keys = {
			{ "<leader>lil", function() Laravel.pickers.laravel() end,              desc = "Laravel: Open Laravel Picker" },
			{ "<c-g>",       function() Laravel.commands.run("view:finder") end,    desc = "Laravel: Open View Finder" },
			{ "<leader>lia", function() Laravel.pickers.artisan() end,              desc = "Laravel: Open Artisan Picker" },
			{ "<leader>lit", function() Laravel.commands.run("actions") end,        desc = "Laravel: Open Actions Picker" },
			{ "<leader>lir", function() Laravel.pickers.routes() end,               desc = "Laravel: Open Routes Picker" },
			{ "<leader>lih", function() Laravel.run("artisan docs") end,            desc = "Laravel: Open Documentation" },
			{ "<leader>lim", function() Laravel.pickers.make() end,                 desc = "Laravel: Open Make Picker" },
			{ "<leader>lic", function() Laravel.pickers.commands() end,             desc = "Laravel: Open Commands Picker" },
			{ "<leader>lio", function() Laravel.pickers.resources() end,            desc = "Laravel: Open Resources Picker" },
			{ "<leader>lip", function() Laravel.commands.run("command_center") end, desc = "Laravel: Open Command Center" },
			{ "<leader>liu", function() Laravel.commands.run("hub") end,            desc = "Laravel Artisan hub" },
			{
				"gf",
				function()
					local ok, res = pcall(function()
						if Laravel.app("gf").cursorOnResource() then
							return "<cmd>lua Laravel.commands.run('gf')<cr>"
						end
					end)
					if not ok or not res then
						return "gf"
					end
					return res
				end,
				expr = true,
				noremap = true,
			},
		},
		opts = {
			features = {
				pickers = {
					provider = "snacks", -- "snacks | telescope | fzf-lua | ui-select"
				},
			},
		},
	}

}
