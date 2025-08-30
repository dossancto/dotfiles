return {
  {
    "numToStr/Comment.nvim",
    opts = {},
    config = function()
      require("Comment").setup({
        sticky = true,
      })
    end,
  },
  {
    "echasnovski/mini.diff",
    lazy = false,
    config = function()
      local diff = require("mini.diff")
      diff.setup()
      -- diff.setup({
      --   -- Disabled by default
      --   source = diff.gen_source.none(),
      -- })
    end,
  },
  {
    -- Make sure to set this up properly if you have lazy=true
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown", "codecompanion" },
    },
    ft = { "markdown", "codecompanion" },
  },
}
