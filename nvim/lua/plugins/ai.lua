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
			prompt_library = {
				["docs"] = {
					interaction = "inline",
					name = "123",
					opts = {
						alias = "docs",
						interaction = "inline",
						auto_submit = true,
						modes = { "v", "n" },
						placement = "replace",
					},
					description = "Generate exhaustive, implementation-free documentation",
					prompts = {
						{
							role = "system",
							content =
							[[You are an expert technical writer specializing in C# and Docusaurus.
Your goal is to write documentation so thorough that a developer never needs to check the source code to understand how to use it.

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
