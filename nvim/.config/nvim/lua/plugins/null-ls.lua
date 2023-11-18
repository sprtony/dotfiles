return {
  -- "jose-elias-alvarez/null-ls.nvim",
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local nls = require("null-ls")
    table.insert(opts.sources, nls.builtins.formatting.prettier)
    table.insert(opts.sources, nls.builtins.formatting.blade_formatter)
  end,
}
