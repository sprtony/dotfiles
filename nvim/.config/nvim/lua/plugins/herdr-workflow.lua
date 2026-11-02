return {
  dir = vim.fn.stdpath("config") .. "/lua/herdr-workflow",
  name = "herdr-workflow",
  config = function()
    require("herdr-workflow").setup()
  end,
}
