vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    use "wbthomason/packer.nvim"

    -- lsp
    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    }

    -- cmp
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
        }
    }
    use "onsails/lspkind.nvim"

    -- library
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use "nvim-treesitter/playground"
    use "p00f/nvim-ts-rainbow"
    use "windwp/nvim-ts-autotag"

    use 'nvim-tree/nvim-web-devicons'

    -- utilities
    use "moll/vim-bbye"
    use "anuvyklack/pretty-fold.nvim"
    use "norcalli/nvim-colorizer.lua"
    use "lukas-reineke/indent-blankline.nvim"

    -- theme
    use "marko-cerovac/material.nvim"

    -- telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use "nvim-telescope/telescope-file-browser.nvim"

    --lines
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use {
        "akinsho/bufferline.nvim",
        tag = "v3.*",
        wants = "nvim-web-devicons"
    }

    --git
    use "lewis6991/gitsigns.nvim"
    use "tpope/vim-fugitive"

    --strings
    use {
        "mattn/emmet-vim",
        setup = function() -- load stuff before the plugin is loaded
            vim.g.user_emmet_leader_key = '<tab>'
            vim.g.user_emmet_mode = 'a'

            vim.g.user_emmet_settings = {
                indent_blockelement = 1,
            }
        end
    }
    use "tpope/vim-commentary"
    use "tpope/vim-surround"
    use "windwp/nvim-autopairs"

    --blade
    use {
        "sheerun/vim-polyglot",
        "jwalton512/vim-blade"
    }

    --read todos
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }

    use {
        "weilbith/nvim-code-action-menu",
        cmd = 'CodeActionMenu',
    }

end)
