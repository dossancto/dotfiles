return {
	-- debug adapter protocol client
	{
		'mfussenegger/nvim-dap',
		lazy = true,
		keys = {
	{ '<Leader>dc', function() require('dap').continue() end,          desc = 'Start/Continue' },
	{ '<Leader>dt', function() require('dap').terminate() end,         desc = 'Terminate' },
	{ '<Leader>dp', function() require('dap').pause() end,             desc = 'Pause' },

	{ '<Leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle Breakpoint' },
	{ '<Leader>dL', function() require('dap').list_breakpoints() end,  desc = 'List Breakpoint' },

	-- REPL window also provide control with interactive commands or mouse
	{ '<Leader>dn', function() require('dap').step_over() end,         desc = 'Step Over' },
	{ '<Leader>di', function() require('dap').step_into() end,         desc = 'Step Into' },
	{ '<Leader>do', function() require('dap').step_out() end,          desc = 'Step Out' },

	{ '<Leader>dk', function() require('dap').up() end,                desc = 'Up in Stacktrace' },
	{ '<Leader>dj', function() require('dap').down() end,              desc = 'Down in Stacktrace' },

	-- REPL: provide command line input/output, better to work with mouse or dap-ui
	{ '<Leader>dr', function() require('dap').repl.toggle() end,       desc = 'Toggle REPL' },
},
		config = function()
			local icon_map = {
				Breakpoint = { ' ' },
				BreakpointCondition = { ' ' },
				BreakpointRejected = { ' ', 'DiagnosticError' },
				LogPoint = { ' ' },
				Stopped = { '󰁕 ', 'DiagnosticWarn', 'DapStoppedLine' },
			}

			-- stylua: ignore
			vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

			for name, sign in pairs(icon_map) do
				vim.fn.sign_define('Dap' .. name, {
					text = sign[1],
					texthl = sign[2] or 'DiagnosticInfo',
					linehl = sign[3],
					numhl = sign[3],
				})
			end

			-- setup adapter and config for specific language
			local dap = require('dap')

			local install_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'mason')

			dap.adapters.netcoredbg = {
				type = 'executable',
				command = install_dir .. '/packages/netcoredbg/netcoredbg',
				args = { '--interpreter=vscode' },
			}

			-- dap: c/cpp/rust
			-- req: gdb 14.0+
			dap.adapters.gdb = {
				type = 'executable',
				command = 'gdb',
				args = { '-i', 'dap' },
			}
			-- req: lldb
			dap.adapters.lldb = {
				type = 'executable',
				command = 'lldb-vscode',
				name = { 'lldb' },
			}
			dap.configurations.c = {
				{
					name = 'Launch',
					type = 'lldb',
					request = 'launch',

					program = function()
						return vim.fn.input(
							'Path to executable: ',
							vim.fn.getcwd() .. '/',
							'file'
						)
					end,
					args = function()
						local args = vim.fn.input('Args: ')
						return vim.split(args, ' ')
					end,
					cwd = '${workspaceFolder}',
					stopOnEntry = false,
				},
			}
			dap.configurations.cpp = dap.configurations.c
			dap.configurations.rust = dap.configurations.c

			-- dap: python
			dap.adapters.debugpy = {
				type = 'executable',
				command = '/usr/bin/python',
				args = { '-m', 'debugpy.adapter' },
			}
			dap.configurations.python = {
				{
					-- required by nvim-dap
					name = 'Launch',
					type = 'debugpy',
					request = 'launch',

					-- options below are for debugpy
					pythonPath = 'python',
					program = function()
						return vim.fn.input(
							'Path to executable: ',
							vim.fn.getcwd() .. '/',
							'file'
						)
					end,
					args = function()
						local args = vim.fn.input('Args: ')
						return vim.split(args, ' ')
					end,
					cwd = '${workspaceFolder}',
				},
			}
		end,
	},

	-- fancy UI for the debugger
	{
		'rcarriga/nvim-dap-ui',
		lazy = true,
		keys = {
	{ '<Leader>de', function() require('dapui').eval() end,   desc = 'DapUI eval' },
},
		opts = {
		},
		dependencies = {
			'mfussenegger/nvim-dap',
			'nvim-neotest/nvim-nio',
			'theHamsta/nvim-dap-virtual-text',
		},
	},
	{
		'igorlfs/nvim-dap-view',
		---@module 'dap-view'
		---@type dapview.Config
		opts = {},
	},

	-- dap virtual text support
	{
		'theHamsta/nvim-dap-virtual-text',
		lazy = true,
		opts = {},
	},
	{
		'nicholasmata/nvim-dap-cs',
		config = function()
			local dap = require('dap')
			dap.set_log_level('TRACE')
			local debug_dll = nil

			local function file_exists(path)
				local stat = vim.loop.fs_stat(path)
				return stat and stat.type == 'file'
			end

			vim.keymap.set('n', '<leader>dj', dap.down, {})
			vim.keymap.set('n', '<leader>dk', dap.up, {})

			require('dap-cs').setup({

				-- Additional dap configurations can be added.
				-- dap_configurations accepts a list of tables where each entry
				-- represents a dap configuration. For more details do:
				-- :help dap-configuration
				dap_configurations = {
					{
						-- Must be "coreclr" or it will be ignored by the plugin
						type = 'coreclr',
						name = 'Attach remote',
						mode = 'remote',
						request = 'attach',
					},
				},
				netcoredbg = {
					path = 'netcoredbg',
				},
			})
		end,
		dependencies = {
			'mfussenegger/nvim-dap',
		},
	},
}
