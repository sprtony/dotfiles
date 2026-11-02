-- PHP / Laravel / Blade IDE support
-- LSP: phpactor (host) -- Formatter: Laravel Pint (local -> sail -> global) + blade-formatter
return {
  -- Herramientas instaladas por Mason
  -- Nota: phpactor / html-lsp / tailwindcss-language-server los instala mason-lspconfig
  --       (evitamos duplicarlos aqui para no disparar instalaciones simultaneas).
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "pint",
        "phpstan",
        "blade-formatter",
        "php-debug-adapter",
      })
    end,
  },

  -- Parsers de Treesitter para PHP y Blade
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      vim.filetype.add({
        pattern = { [".*%.blade%.php"] = "blade" },
      })
    end,
    opts = {
      ensure_installed = { "php", "php_only", "phpdoc", "blade", "html" },
    },
  },

  -- Formateo PHP (Pint local -> sail -> global) y Blade
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      local util = require("conform.util")
      local composer_root = util.root_file({ "composer.json" })

      opts.formatters = opts.formatters or {}

      opts.formatters.pint_local = {
        command = "vendor/bin/pint",
        args = { "$FILENAME" },
        stdin = false,
        cwd = composer_root,
        condition = function(self, ctx)
          local root = composer_root(self, ctx)
          return root ~= nil and vim.fn.executable(root .. "/vendor/bin/pint") == 1
        end,
      }

      opts.formatters.pint_sail = {
        command = "vendor/bin/sail",
        args = { "pint", "$RELATIVE_FILEPATH" },
        stdin = false,
        cwd = composer_root,
        condition = function(self, ctx)
          local root = composer_root(self, ctx)
          return root ~= nil and vim.fn.executable(root .. "/vendor/bin/sail") == 1
        end,
      }

      opts.formatters.pint_global = {
        command = "pint",
        args = { "$FILENAME" },
        stdin = false,
        condition = function()
          return vim.fn.executable("pint") == 1
        end,
      }

      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.php = { "pint_local", "pint_sail", "pint_global", "php_cs_fixer" }
      opts.formatters_by_ft.blade = { "blade-formatter" }
    end,
  },

  -- LSP: HTML y Tailwind tambien dentro de Blade
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {
          filetypes = { "html", "blade" },
        },
        tailwindcss = {
          filetypes = {
            "html",
            "css",
            "scss",
            "sass",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "vue",
            "svelte",
            "blade",
            "php",
          },
          init_options = {
            userLanguages = {
              blade = "html",
              php = "html",
            },
          },
        },
      },
    },
  },

  -- Laravel: pickers, smart gf, completion, artisan hub, tinker, entornos
  {
    "adalessa/laravel.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
    },
    ft = { "php", "blade" },
    event = { "BufEnter composer.json" },
    keys = {
      { "<leader>Ll", function() Laravel.pickers.laravel() end, desc = "Laravel: Picker" },
      { "<leader>La", function() Laravel.pickers.artisan() end, desc = "Laravel: Artisan" },
      { "<leader>Lr", function() Laravel.pickers.routes() end, desc = "Laravel: Rutas" },
      { "<leader>Lm", function() Laravel.pickers.make() end, desc = "Laravel: Make" },
      { "<leader>Lo", function() Laravel.pickers.resources() end, desc = "Laravel: Recursos" },
      { "<leader>Lc", function() Laravel.pickers.commands() end, desc = "Laravel: Comandos" },
      { "<leader>Lt", function() Laravel.commands.run("actions") end, desc = "Laravel: Code Actions" },
      { "<leader>Lu", function() Laravel.commands.run("hub") end, desc = "Laravel: Artisan Hub" },
      { "<leader>Lp", function() Laravel.commands.run("command_center") end, desc = "Laravel: Command Center" },
      { "<leader>Lh", function() Laravel.run("artisan docs") end, desc = "Laravel: Documentacion" },
      { "<leader>Lv", function() Laravel.commands.run("view:finder") end, desc = "Laravel: View Finder" },
      {
        "gf",
        function()
          if Laravel.app("gf").cursorOnResource() then
            return "<cmd>lua Laravel.commands.run('gf')<cr>"
          end
          return "gf"
        end,
        expr = true,
        noremap = true,
        desc = "Laravel: Ir al recurso",
      },
    },
    opts = function(_, opts)
      opts.features = opts.features or {}
      opts.features.pickers = vim.tbl_deep_extend("force", opts.features.pickers or {}, {
        provider = "snacks",
      })

      opts.environments = opts.environments or {}
      opts.environments.ask_on_boot = true

      local root = vim.fs.root(0, { "composer.json", "artisan" }) or vim.fn.getcwd()
      opts.environments.default = vim.fn.executable(root .. "/vendor/bin/sail") == 1 and "sail" or "local"
    end,
  },

  -- Debugging PHP con Xdebug (puerto 9003)
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      dap.configurations.php = dap.configurations.php or {}
      table.insert(dap.configurations.php, {
        type = "php",
        request = "launch",
        name = "Escuchar Xdebug (9003)",
        port = 9003,
      })
    end,
  },
}
