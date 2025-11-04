-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("lspconfig").dartls.setup({
            cmd = { "dart", "language-server", "--protocol=lsp" },
            filetypes = { "dart" },
            init_options = {
                closingLabels = true,
                flutterOutline = true,
                onlyAnalyzeProjectsWithOpenFiles = true,
                outline = true,
                suggestFromUnimportedLibraries = true,
            },
            -- root_dir = root_pattern("pubspec.yaml"),
            settings = {
                dart = {
                    completeFunctionCalls = true,
                    showTodos = true,
                },
            },
            on_attach = function(client, bufnr)
            end,
        })


-- local mason_lspconfig = require("mason-lspconfig")
--
-- mason_lspconfig.setup({
--   handlers = {
--     rust_analzer = function() end,
--   },
-- })

-- local cmd = {
--   "mise",
--   "exec",
--   "dotnet@9",
-- }
--
-- vim.lsp.config("rust-analyzer", {
--   cmd = cmd,
-- })
