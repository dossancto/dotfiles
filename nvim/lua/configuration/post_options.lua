vim.lsp.config('roslyn', {
	on_attach = function() end,
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

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
			callback = function()
				local buf = vim.api.nvim_get_current_buf()
				local success, _ = pcall(vim.treesitter.get_parser, buf)
				if success then
					vim.treesitter.stop(buf) -- Reset
					vim.treesitter.start(buf) -- Start
				end
			end,
		})
	end,
})
