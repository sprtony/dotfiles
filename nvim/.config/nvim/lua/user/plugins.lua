local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use "wbthomason/packer.nvim"
  -- Library
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
  use {"nvim-treesitter/nvim-treesitter", run = ':TSUpdate'}

  -- Utilidades
  use "moll/vim-bbye" -- Cerrar los buffers sin cerrar vim
  use "ahmedkhalf/project.nvim" -- control de proyectos
  use "lewis6991/impatient.nvim" -- Cache para lua
  use "lukas-reineke/indent-blankline.nvim" -- lina blanca de las identaciones
  use "goolord/alpha-nvim" -- pagina de inicio al nvim
  use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight
  use "voldikss/vim-floaterm" -- Terminal flotante
  use "norcalli/nvim-colorizer.lua"

  -- Colorschemes
  -- use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
  use "lunarvim/darkplus.nvim"
  use "joshdick/onedark.vim"

  -- manejo de line
  use "akinsho/bufferline.nvim"
  use "nvim-lualine/lualine.nvim"

  -- Telescope
  use "nvim-telescope/telescope.nvim"
  use "nvim-telescope/telescope-project.nvim"
  use "nvim-telescope/telescope-media-files.nvim"
  use "sudormrfbin/cheatsheet.nvim"
  use {
    "AckslD/nvim-neoclip.lua",
    config = function()
      require('neoclip').setup()
    end
  }
  use "gfeiyou/command-center.nvim"
  use "fannheyward/telescope-coc.nvim"
  use "nvim-telescope/telescope-file-browser.nvim"
  use "nvim-telescope/telescope-dap.nvim"

  -- Git
  use "kdheepak/lazygit.nvim"

  -- COC
  use {"neoclide/coc.nvim", branch='release'}

  -- Laravel
  use "sheerun/vim-polyglot"
  use "jwalton512/vim-blade"
  use "tpope/vim-dispatch"             
  use "tpope/vim-projectionist"        
  use "noahfrederick/vim-composer"     
  use "noahfrederick/vim-laravel"
  use "mattn/emmet-vim"

  -- Flutter
  use "dart-lang/dart-vim-plugin"

  --TEST
  use "vim-test/vim-test"

  --PUG
  use "digitaltoad/vim-pug"

  --DAP
  use "mfussenegger/nvim-dap"
  use "rcarriga/nvim-dap-ui"

  --Strings
  use "tpope/vim-surround"
  use "windwp/nvim-autopairs"
  use "junegunn/rainbow_parentheses.vim"
  use "tpope/vim-commentary"

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
