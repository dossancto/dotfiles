vim.g.mapleader = " "
vim.cmd("language en_US.utf8")

require("configuration.options")
require("configuration.keybinds.init")

require("init.lazy_pre").check_load_lazy()
vim.cmd("colorscheme vague")
require("init.lsp")
require("configuration.post_options")

vim.cmd('set guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"')

require("codecompanion").setup({
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
        "~/.dotfiles/.config/prompts", -- Or absolute paths
      },
    },	},

})
