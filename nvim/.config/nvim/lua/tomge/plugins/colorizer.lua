-- NvChad/nvim-colorizer.lua
require("colorizer").setup({
	filetypes = {
		"css",
		"javascript",
		"html",
		"lua",
		-- Add any other filetypes you want here
	},
	user_default_options = {
		RGB = true, -- #RGB hex codes
		RRGGBB = true, -- #RRGGBB hex codes
		names = false, -- "Name" codes like Blue or Gray
		RRGGBBAA = true, -- #RRGGBBAA hex codes
		rgb_fn = true, -- CSS rgb() and rgba() functions
		hsl_fn = true, -- CSS hsl() and hsla() functions
		css = true, -- Enable all CSS features: rgb_fn, hsl_fn
		css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
		mode = "background", -- Set the display mode
	},
})
