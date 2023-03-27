return {
  "akinsho/flutter-tools.nvim",
  dependencies = { "williamboman/mason-lspconfig.nvim", "nvim-lua/plenary.nvim" },
  event = "BufRead",
  config = function()
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
