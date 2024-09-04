return {
  "akinsho/flutter-tools.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
  },
  lazy = false,
  event = "BufRead",
  opts = function()
    require("flutter-tools").setup({
      server = {
        color = {
          enabled = true,
        },
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
        },
      },
    })
  end,
}
