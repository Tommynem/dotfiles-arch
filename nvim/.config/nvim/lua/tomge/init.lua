require("tomge.lazy")
require("tomge.remap")
require("tomge.diagnostics")
require("Comment").setup()

-- Load theme switcher after all plugins (with VimEnter event)
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		require("tomge.plugins.theme-switcher")
	end,
	once = true,
})
