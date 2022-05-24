local gears = require("gears")
local dock = require("module.dock.dock")
dock.init({
	screen = screen.primary,
	height = dpi(50),
	offset = dpi(5),
	inner_shape = gears.shape.rounded_rect,
})
