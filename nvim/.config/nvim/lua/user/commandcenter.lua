require("telescope").load_extension('command_center')
local command_center = require("command_center")
local noremap = {noremap = true}
local silent_noremap = {noremap = true, silent = true}

command_center.add({
  {
    description = "Find files",
    cmd = "<CMD>Telescope find_files<CR>",
    keybindings = { "n", "<leader>ff", noremap },
  }, {
    description = "Search inside current buffer",
    cmd = "<CMD>Telescope current_buffer_fuzzy_find<CR>",
  }, {
    description = "Abrir LazyGit",
    cmd = "<CMD>LazyGit<CR>"
  }, {
    description = "DEBUG continue",
    cmd = "<CMD>lua require'dap'.continue()<CR>",
    keybindings = { "n", "<F5>", noremap}
  }, {
    description = "DEBUG step over",
    cmd = "<CMD>lua require'dap'.step_over()<CR>",
    keybindings = { "n", "<F10>", noremap}
  }, {
    description = "DEBUG step into",
    cmd = "<CMD>lua require'dap'.step_into()<CR>",
    keybindings = { "n", "<F11>", noremap}
  }, {
    description = "DEBUG step out",
    cmd = "<CMD>lua require'dap'.step_out()<CR>",
    keybindings = { "n", "<F12>", noremap}
  }, {
    description = "DEBUG breakpoint",
    cmd = "<CMD>lua require'dap'.toggle_breakpoint()<CR>",
    keybindings = { "n", "<leader>b", noremap}
  }, {
    description = "DEBUG repl",
    cmd = "<CMD>lua require'dap'.repl.open()<CR>",
    keybindings = { "n", "<leader>dr", noremap}
  }
}, command_center.mode.ADD_AND_REGISTER)


-- DAP
-- keymap("n", "<Leader>dc",":lua require'dap'.continue()<CR>",opts)
-- keymap("n", "<Leader>do",":lua require'dap'.step_out()<CR>",opts)
-- keymap("n", "<Leader>di",":lua require'dap'.step_into()<CR>",opts)
-- keymap("n", "<Leader>dv",":lua require'dap'.step_over()<CR>",opts)
-- keymap("n", "<Leader>db",":lua require'dap'.toggle_breakpoint()<CR>",opts)
-- keymap("n", "<Leader>dr",":lua require'dap'.repl.open()<CR>",opts)

