return {
	{
		'olimorris/codecompanion.nvim',
		-- opts = {
		-- 	extensions = {
		-- 		mcphub = {
		-- 			callback = 'mcphub.extensions.codecompanion',
		-- 			opts = {
		-- 				-- MCP Tools
		-- 				make_tools = true,  -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
		-- 				show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
		-- 				add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
		-- 				show_result_in_chat = true, -- Show tool results directly in chat buffer
		-- 				format_tool = nil,  -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
		-- 				-- MCP Resources
		-- 				make_vars = true,   -- Convert MCP resources to #variables for prompts
		-- 				-- MCP Prompts
		-- 				make_slash_commands = true, -- Add MCP prompts as /slash commands
		-- 			},
		-- 		},
		-- 	},
		-- },
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-treesitter/nvim-treesitter',
			'ravitemer/mcphub.nvim',
			'github/copilot.vim',
			'kkrampis/codex.nvim',
		},
		prompt_library = {
			["docs"] = {
				interaction = "inline",
				opts = {
					alias = "docs",
					auto_submit = true,
					modes = { "v" },
					placement = "new",
					stop_context_insertion = true,
				},
				description = "Generate exhaustive, implementation-free documentation",
				prompts = {
					{
						role = "system",
						content = [[You are an expert technical writer specializing in C# and Docusaurus.
Your goal is to write documentation so thorough that a developer never needs to check the source code to understand how to use it.

### Strict Rules:
1. **No Redundancy**: Never use "Gets or sets" for C# properties. Start directly with the description of the value or state the property represents.
2. **Context & Intent**: Explain *why* a method exists and what its high-level goal is.
3. **Parameters & Returns**: Explicitly define every parameter, its expected range/type, and exactly what the return value represents.
4. **Exceptions & Edge Cases**: Document what happens when things go wrong (e.g., NullReference, ArgumentException).
5. **Formatting**: Use clean Markdown compatible with Docusaurus. Use code blocks for examples if necessary.
6. **No Implementation Details**: Do not explain *how* the code works internally; explain *what* it achieves for the consumer.
7. **Only the selected code**: Only document the selected code, dont try to doc something that is not the main focus.]],
					},
					{
						role = "user",
						content = "Create comprehensive documentation for the following code:\n\n",
					},
				},
			},
		},
	},
	-- {
	-- 	'ravitemer/mcphub.nvim',
	-- 	dependencies = {
	-- 		'nvim-lua/plenary.nvim',
	-- 	},
	-- 	build = 'npm install -g mcp-hub@latest', -- Installs `mcp-hub` node binary globally
	-- 	config = function()
	-- 		require('mcphub').setup()
	-- 	end,
	-- },
}
