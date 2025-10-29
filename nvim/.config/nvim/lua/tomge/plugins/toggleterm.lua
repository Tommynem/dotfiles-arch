-- akinsho/toggleterm.nvim
require("toggleterm").setup({
	size = 20,
	open_mapping = [[<c-\>]],
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	persist_size = true,
	direction = "horizontal", -- can be 'vertical' or 'float'
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		width = math.floor(vim.o.columns * 0.8),
		height = math.floor(vim.o.lines * 0.8),
		winblend = 0,
	},
})

local Terminal = require("toggleterm.terminal").Terminal

-- Create a floating terminal instance
local float_term = Terminal:new({
	direction = "float",
	float_opts = {
		border = "curved",
		width = math.floor(vim.o.columns * 0.8),
		height = math.floor(vim.o.lines * 0.8),
	},
	on_open = function(term)
		vim.cmd("startinsert!")
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
	end,
	on_close = function(term)
		vim.cmd("startinsert!")
	end,
})

function _FLOAT_TERM_TOGGLE()
	float_term:toggle()
end
