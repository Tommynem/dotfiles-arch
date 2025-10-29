-- akinsho/bufferline.nvim
-- Temporarily using default setup until catppuccin loads properly
require("bufferline").setup({})

-- Setup catppuccin integration after colorscheme loads
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "catppuccin*",
	callback = function()
		local ok, catppuccin_bufferline = pcall(require, "catppuccin.groups.integrations.bufferline")
		if ok and catppuccin_bufferline.get_theme then
			local theme_ok, theme = pcall(catppuccin_bufferline.get_theme)
			if theme_ok and theme then
				require("bufferline").setup({
					highlights = theme,
				})
			end
		end
	end,
})
