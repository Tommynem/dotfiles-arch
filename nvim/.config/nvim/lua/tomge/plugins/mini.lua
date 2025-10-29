-- echasnovski/mini.nvim

-- Disable mini.sessions since we're using auto-session instead
vim.g.minisessions_disable = true

require("mini.move").setup({
	mappings = {
		left = "<C-Left>",
		right = "<C-Right>",
		down = "<C-Down>",
		up = "<C-Up>",
		line_left = "<C-Left>",
		line_right = "<C-Right>",
		line_down = "<C-Down>",
		line_up = "<C-Up>",
	},
})
require("mini.bufremove").setup({})
-- TODO: Maybe switch to this later for fancier completion preview
-- require("mini.completion").setup({
-- 	lsp_completion = {
-- 		source_func = "omnifunc", -- or "completefunc"
-- 		auto_setup = true,
-- 	},
-- })
require("mini.icons").setup({})
require("mini.map").setup({
	symbols = {
		encode = require("mini.map").gen_encode_symbols.dot("4x2"),
	},
	window = {
		side = "right", -- "left" or "right"
		width = 10, -- actual char width
		winblend = 25, -- transparency
		show_integration_count = false,
	},
	integrations = {
		require("mini.map").gen_integration.diagnostic(),
		require("mini.map").gen_integration.gitsigns(),
	},
})
