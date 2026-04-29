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
		lazy = false,
		dependencies = {
			'nvim-lua/plenary.nvim',
			'stevearc/dressing.nvim', -- optional for vim.ui.select
		},
		config = true,
	},

}
