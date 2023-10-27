version = "0.21.0"

local home = os.getenv("HOME")

local xpm_path = home .. "/.local/share/xplr/dtomvan/xpm.xplr"
local xpm_url = "https://github.com/dtomvan/xpm.xplr"

package.path = package.path .. ";" .. xpm_path .. "/?.lua;" .. xpm_path .. "/?/init.lua"

os.execute(string.format("[ -e '%s' ] || git clone '%s' '%s'", xpm_path, xpm_url, xpm_path))

require("xpm").setup({
	plugins = {
		-- Let xpm manage itself
		{ name = "dtomvan/xpm.xplr" },
		{ name = "prncss-xyz/icons.xplr" },
		{
			name = "dtomvan/extra-icons.xplr",
			after = function()
				xplr.config.general.table.row.cols[2] = { format = "custom.icons_dtomvan_col_1" }
			end,
		},
		{
			name = "dtomvan/ouch.xplr",
			setup = {
				mode = "action",
				key = "o",
			},
		},
	},

	auto_install = true,
	auto_cleanup = true,
})
