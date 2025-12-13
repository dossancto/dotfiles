return {
  {
    "olimorris/codecompanion.nvim",
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "github/copilot.vim",
      "nvim-treesitter/nvim-treesitter",
    },
  },

  {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<A-f>",
          clear_suggestion = "<C-]>",
          accept_word = "<C-j>",
        },
      })
    end,
  },

  -- {
  --   "monkoose/neocodeium",
  --   event = "VeryLazy",
  --   config = function()
  --     local neocodeium = require("neocodeium")
  --     neocodeium.setup()
  --     vim.keymap.set("i", "<A-f>", neocodeium.accept)
  --   end,
  -- },

  -- {
  --   "Exafunction/windsurf.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim"
  --   },
  --   config = function()
  --     require("codeium").setup({})
  --   end,
  -- },
  -- {
  --   "Exafunction/windsurf.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  --   config = function()
  --     require("codeium").setup({})
  --   end,
  -- },
}
