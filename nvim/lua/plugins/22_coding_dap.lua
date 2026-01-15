local keymap = require('init.keymaps')

return {
	-- debug adapter protocol client
	{
		'mfussenegger/nvim-dap',
		lazy = true,
		keys = keymap.dap,
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
		keys = keymap.dapui,
		opts = { log_level = vim.log.levels.OFF },
		config = function(_, opts)
			local dap, dapui = require('dap'), require('dapui')
			dapui.setup(opts)
			dap.listeners.after.event_initialized['dapui_config'] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated['dapui_config'] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited['dapui_config'] = function()
				dapui.close()
			end
		end,
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
		lazy = false,
		config = function()
			local dap = require('dap')
			-- local dotnet = require("easy-dotnet")
			-- local dapui = require("dapui")
			dap.set_log_level('TRACE')
			local debug_dll = nil

			-- local function ensure_dll()
			--   if debug_dll ~= nil then
			--     return debug_dll
			--   end
			--   local dll = dotnet.get_debug_dll()
			--   debug_dll = dll
			--   return dll
			-- end

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

						-- type = "coreclr",
						-- name = "Program",
						-- request = "launch",
						-- env = function()
						--   local dll = ensure_dll()
						--   local vars = dotnet.get_environment_variables(dll.project_name, dll.absolute_project_path)
						--   return vars or nil
						-- end,
						-- program = function()
						--   local dll = ensure_dll()
						--   local co = coroutine.running()
						--   rebuild_project(co, dll.project_path)
						--   if not file_exists(dll.target_path) then
						--     error("Project has not been built, path: " .. dll.target_path)
						--   end
						--   return dll.target_path
						-- end,
						-- cwd = function()
						--   local dll = ensure_dll()
						--   return dll.absolute_project_path
						-- end,
					},
				},
				netcoredbg = {
					-- the path to the executable netcoredbg which will be used for debugging.
					-- by default, this is the "netcoredbg" executable on your PATH.
					path = 'netcoredbg',
				},
			})
		end,
		dependencies = {
			'mfussenegger/nvim-dap',
			'Exafunction/codeium.nvim',
		},
	},
}
