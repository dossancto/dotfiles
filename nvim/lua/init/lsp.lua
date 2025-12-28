vim.lsp.config('ts_ls', {
	filetypes = {
		'typescript',
		'javascript',
		'javascriptreact',
		'typescriptreact',
		'vue',
	},
	init_options = {
		plugins = {
			{
				name = '@vue/typescript-plugin',
				location = vim.fn.stdpath('data')
					.. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
				languages = { 'vue' },
			},
		},
	},
})

vim.lsp.config('vue_ls', {
	{
		init_options = {
			vue = {
				hybridMode = false,
			},
		},
		settings = {
			typescript = {
				inlayHints = {
					enumMemberValues = {
						enabled = true,
					},
					functionLikeReturnTypes = {
						enabled = true,
					},
					propertyDeclarationTypes = {
						enabled = true,
					},
					parameterTypes = {
						enabled = true,
						suppressWhenArgumentMatchesName = true,
					},
					variableTypes = {
						enabled = true,
					},
				},
			},
		},
	},
})
