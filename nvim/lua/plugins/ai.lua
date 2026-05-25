return {
	{
		'olimorris/codecompanion.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-treesitter/nvim-treesitter',
			'github/copilot.vim',
			'kkrampis/codex.nvim',
		},
		opts = {
			display = {
				action_palette = {
					width = 95,
					height = 10,
					prompt = "Prompt ", -- Prompt used for interactive LLM calls
					provider = "default", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
					opts = {
						show_preset_actions = true, -- Show the preset actions in the action palette?
						show_preset_prompts = true, -- Show the preset prompts in the action palette?
						title = "CodeCompanion actions", -- The title of the action palette
					},
				},
			},

			prompt_library = {
				markdown = {
					dirs = {
						vim.fn.getcwd() .. "/.prompts", -- Can be relative
						"~/.dotfiles/ai/prompts/", -- Or absolute paths
					},
				},
			},

### Strict Rules:
1. **No Redundancy**: Never use "Gets or sets" for C# properties. Start directly with the description of the value or state the property represents.
2. **Context & Intent**: Explain *why* a method exists and what its high-level goal is.
3. **Parameters & Returns**: Explicitly define every parameter, its expected range/type, and exactly what the return value represents.
4. **Exceptions & Edge Cases**: Document what happens when things go wrong (e.g., NullReference, ArgumentException).
5. **No Implementation Details**: Do not explain *how* the code works internally; explain *what* it achieves for the consumer.
]],
						},
						{
							role = "user",
							content = function(context)
								local text = require("codecompanion.helpers.actions")
								    .get_code(context.start_line, context.end_line)

								return "Please doc the following code:\n\n```" ..
								    context.filetype .. "\n" .. text .. "\n```"
							end,
						},
					},
				},
			},

		},
	},
}
