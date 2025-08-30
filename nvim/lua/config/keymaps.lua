-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set
local unmap = vim.keymap.del

local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

map("n", ";", ":", { desc = "CMD enter command mode" })

-- Navigation

unmap("n", "F")
map("n", "F", "<cmd>Spectre<cr>", { desc = "Open Spectre" })
map("n", "<leader>F", "<cmd>Spectre<cr>", { desc = "Open Spectre" })

-- IA
map({"n", "v"}, "<leader>aa", "<cmd>CodeCompanion<cr>", { desc = "Open Companion" })
map({"n", "v"}, "<leader>at", "<cmd>CodeCompanionChat toggle<cr>", { desc = "Open Companion" })
map("n", "<leader>ac", "<cmd>CodeCompanionActions<cr>", { desc = "Open Companion Help" })

-- LSP
unmap("n", "<leader>l")

map("n", "<leader>lj", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "<leader>lk", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
-- map("n", "<leader>lj", diagnostic_goto(true), { desc = "Next Diagnostic" })
-- map("n", "<leader>lk", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Actions" })

map({ "n", "v" }, "<leader>/", "<cmd>normal gcc<cr>", { desc = "Toggle Comment", remap = true })
map({ "n", "v" }, "<leader>\\", "gcc", { desc = "Toggle Comment", remap = true })

map({ "n", "v" }, "<leader>fm", function()
  sticky = true, LazyVim.format({ force = true })
end, { desc = "Format" })

-- dap
map("n", "<Leader>dU", "<cmd>DapViewToggle<cr>")
map("n", "<Leader>dc", "<cmd>DapContinue<cr>")
map("n", "<Leader>dt", "<cmd>DapToggleBreakpoint<cr>")
map("n", "<Leader>dd", "<cmd>DapDisconnect<cr>")
map("n", "<Leader>di", "<cmd>DapStepInto<cr>")
map("n", "<Leader>du", "<cmd>DapStepOut<cr>")
map("n", "<Leader>do", "<cmd>DapStepOver<cr>")
map("n", "<Leader>dC", "<cmd>lua require'dap'.run_to_cursor()<cr>")

map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
map("n", "gd", "<cmd>Telescope lsp_definitions<CR>")
map("n", "gi", "<cmd>Telescope lsp_implementations<CR>")
map("n", "gr", "<cmd>Telescope lsp_references<CR>")
map("n", "gs", "<cmd>Telescope lsp_document_symbols<CR>")
map("n", "<Leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>")
-- map("n", "<Leader>ld", "<cmd>Dotnet<CR>")

-- Git
map("n", "<Leader>gk", "<cmd>Gitsigns prev_hunk<cr>")
map("n", "<Leader>gj", "<cmd>Gitsigns next_hunk<cr>")
map("n", "<Leader>go", "<cmd>Telescope git_status<cr>")
map("n", "<Leader>gm", "<cmd>DiffviewOpen<cr>")
map("n", "<leader>gt", "<cmd>Telescope git_stash<CR>", { desc = "telescope git stash" })
map("n", "<Leader>gC", "<cmd>DiffviewClose<cr>")
-- map("n", "<Leader>gh", "<cmd>DiffviewFileHistory %<cr>")
map("n", "<Leader>ge", "<cmd>DiffviewToggleFiles<cr>")
map("n", "<Leader>gn", "<cmd>GitBlameCopyCommitURL<cr>")
map("n", "<Leader>gr", "<cmd>Gitsigns reset_hunk<cr>")
map("n", "<Leader>gg", "<cmd>Gitui<cr>")

-- Bookmarks
-- unmap('n', '<leader>bb')
-- map('n', '<leader>bb', ':MinimalBookmarksToggle<CR>', { noremap = true, silent = true })
-- map('n', '<leader>be', ':MinimalBookmarksEdit<CR>', { noremap = true, silent = true })
-- map('n', '<leader>ba', ':MinimalBookmarksAdd<CR>', { noremap = true, silent = true })
-- map('n', '<leader>bi', ':MinimalBookmarksInsert<CR>', { noremap = true, silent = true })
-- map('n', '<leader>bd', ':MinimalBookmarksDelete<CR>', { noremap = true, silent = true })

if vim.fn.has("nvim-0.11") == 0 then
  map("s", "<Tab>", function()
    return vim.snippet.active({ direction = 1 }) and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
  end, { expr = true, desc = "Jump Next" })
  map({ "i", "s" }, "<S-Tab>", function()
    return vim.snippet.active({ direction = -1 }) and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<S-Tab>"
  end, { expr = true, desc = "Jump Previous" })
end
