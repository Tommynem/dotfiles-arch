-- obsidian.nvim config
require("obsidian").setup({

	workspaces = {
		{
			name = "vault",
			path = vim.env.OBSIDIAN_VAULT_PATH or vim.fn.expand("~/Documents/ObsidianVault"),
		},
	},
	opts = {

		completion = {
			nvim_cmp = false, -- Disabled in favor of blink.cmp
		},
		picker = {
			name = "telescope.nvim",
		},
		ui = {
			enable = true,
			checkboxes = {
				[" "] = { char = "☐", hl_group = "ObsidianTodo" },
				["x"] = { char = "✔", hl_group = "ObsidianDone" },
			},
		},
		attachments = {
			img_folder = "pasted/images",
		},
	},
})
