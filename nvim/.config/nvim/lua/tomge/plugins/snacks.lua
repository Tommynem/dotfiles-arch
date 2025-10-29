-- lua/tomge/plugins/snacks.lua
local M = {}

function M.setup()
	local snacks = require("snacks")

	snacks.setup({
		git = { enabled = true },
		gitbrowse = { enabled = true },
		lazygit = { enabled = true },
		input = { enabled = true },
		notifier = {
			enabled = true,
			timeout = 6000,
		},
		quickfile = { enabled = true },
		rename = { enabled = true },
		dashboard = {
			enabled = true,
			sections = {
				{ section = "header" },
				{
					pane = 2,
					section = "terminal",
					cmd = "colorscript -e square",
					height = 5,
					padding = 1,
				},
				{ section = "keys", gap = 1, padding = 1 },
				{ pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
				{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
				{
					pane = 2,
					icon = " ",
					title = "Git Status",
					section = "terminal",
					enabled = function()
						return Snacks.git.get_root() ~= nil
					end,
					cmd = "git status --short --branch --renames",
					height = 5,
					padding = 1,
					ttl = 5 * 60,
					indent = 3,
				},
				{ section = "startup" },
			},
		},
	})

	-- Set up keybindings
	vim.keymap.set("n", "<leader>sd", function()
		snacks.dashboard()
	end, { desc = "Open Dashboard" })

	vim.keymap.set("n", "<leader>.", function()
		snacks.dashboard()
	end, { desc = "Open Dashboard" })
end

return M
