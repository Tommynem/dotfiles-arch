local ls = require("luasnip")
local types = require("luasnip.util.types")

ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	enable_autosnippets = true,
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "●", "GruvboxOrange" } },
			},
		},
		[types.insertNode] = {
			active = {
				virt_text = { { "●", "GruvboxBlue" } },
			},
		},
	},
})

-- Load friendly-snippets (VSCode snippets)
require("luasnip.loaders.from_vscode").lazy_load()

-- Load custom snippets from snippets directory
require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/lua/tomge/snippets" })

-- Keymaps for snippet navigation
vim.keymap.set({ "i", "s" }, "<C-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true, desc = "Expand snippet or jump forward" })

vim.keymap.set({ "i", "s" }, "<C-j>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true, desc = "Jump backward in snippet" })

vim.keymap.set({ "i", "s" }, "<C-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true, desc = "Cycle through snippet choices" })

vim.keymap.set({ "i", "s" }, "<C-h>", function()
	if ls.choice_active() then
		ls.change_choice(-1)
	end
end, { silent = true, desc = "Cycle backward through snippet choices" })

-- Refresh snippets command
vim.keymap.set("n", "<leader>sr", "<cmd>source ~/.config/nvim/lua/tomge/plugins/luasnip.lua<CR>", {
	desc = "Reload snippets",
})