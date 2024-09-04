return {
  { "nvim-neotest/neotest-plenary" },
  { "theutz/neotest-pest" },
  { "sidlatau/neotest-dart" },
  { "olimorris/neotest-phpunit" },
  {
    "nvim-neotest/neotest",
    opts = {
      adapters = {
        "neotest-plenary",
        "neotest-dart",
        -- "neotest-pest",
        ["neotest-phpunit"] = {
          filter_dirs = function()
            return { ".git", "node_modules", "vendor" }
          end,
        },
      },
    },
  },
}
