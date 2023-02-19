require 'nvim-treesitter.configs'.setup {

    ensure_installed = { "php", "lua", "javascript", "css", "scss", "html", "pug", "vue" },
    sync_install = false,
    auto_install = true,
    ignore_install = {},

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true
    },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
    },
    autotag = {
        enable = true,
    }
}
