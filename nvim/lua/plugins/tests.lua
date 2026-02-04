return {
	{
		'nvim-neotest/neotest',
		dependencies = {
			'nvim-neotest/nvim-nio',
			'Issafalcon/neotest-dotnet',
			'nvim-lua/plenary.nvim',
			'antoinemadec/FixCursorHold.nvim',
			'nvim-treesitter/nvim-treesitter',
		},
		config = function()
			require('neotest').setup({
				adapters = {
					require('neotest-dotnet')({
						dap = {
							adapter_name = 'netcoredbg',
							args = { justMyCode = true },
						},
						-- dotnet_test_executable = 'dotnet',
					}),
				},
			})
		end,
	},
}
