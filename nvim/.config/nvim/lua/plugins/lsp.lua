return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        intelephense = {
          cmd = { "intelephense", "--stdio" },
          filetypes = { "blade", "php" },
        },
        emmet_ls = {
          cmd = { "emmet-ls", "--stdio" },
          filetypes = {
            "astro",
            "astro-markdown",
            "blade",
            "html",
            "markdown",
            "php",
            "css",
            "sass",
            "scss",
            "javascript",
            "typescript",
            "vue",
          },
          init_options = {
            html = {
              options = {
                ["bem.enabled"] = true,
              },
            },
          },
        },
        tailwindcss = {
          cmd = { "tailwindcss-language-server", "--stdio" },
          filetypes = {
            "astro",
            "astro-markdown",
            "blade",
            "html",
            "markdown",
            "php",
            "css",
            "sass",
            "scss",
            "javascript",
            "typescript",
            "vue",
          },
        },
      },
    },
  },
}
