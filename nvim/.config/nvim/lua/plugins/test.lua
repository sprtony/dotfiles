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
        "neotest-pest",
        "neotest-dart",
        "neotest-phpunit",
      },
    },
  },
}
