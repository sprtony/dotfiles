vim.o.number = true
vim.o.relativenumber = true

vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldenable = false

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true

vim.o.clipboard = "unnamedplus"

vim.o.timeoutlen = 500
vim.o.updatetime = 300

vim.g.material_style = "deep ocean"
vim.cmd "colorscheme material"

