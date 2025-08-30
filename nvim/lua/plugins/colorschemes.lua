return {
  {
    "rebelot/kanagawa.nvim",
  },
  { "datsfilipe/min-theme.nvim" },
  {
    "sainnhe/gruvbox-material",
  },
  {
    "shaunsingh/nord.nvim",
  },
  {
    "anAcc22/sakura.nvim",
    dependencies = "rktjmp/lush.nvim",
    config = function()
      vim.opt.background = "dark" -- or "light"
    end,
  },
  {
    "navarasu/onedark.nvim",
    -- priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("onedark").setup({
        style = "warmer",
      })
      -- Enable theme
      require("onedark").load()
    end,
  },
}
