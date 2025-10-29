local wk = require("which-key")

wk.setup({
	preset = "modern",
	delay = function(ctx)
		-- Don't delay for single character mappings like gd, gr
		if ctx.keys and string.len(ctx.keys) == 2 and string.sub(ctx.keys, 1, 1) == "g" then
			return 0
		end
		return 200
	end,
	expand = 1,
	notify = false,
	show_help = true,
	show_keys = true,
	disable = {
		buftypes = {},
		filetypes = {},
	},
	replace = {
		["<space>"] = "SPC",
		["<cr>"] = "RET",
		["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»",
		separator = "➜",
		group = "+",
		ellipsis = "…",
		mappings = vim.g.have_nerd_font,
		keys = {
			Up = " ",
			Down = " ",
			Left = " ",
			Right = " ",
			C = "󰘴 ",
			M = "󰘵 ",
			D = "󰘳 ",
			S = "󰘶 ",
			CR = "󰌑 ",
			Esc = "󱊷 ",
			ScrollWheelDown = "󱕐 ",
			ScrollWheelUp = "󱕑 ",
			NL = "󰌑 ",
			BS = "󰁮",
			Space = "󱁐 ",
			Tab = "󰌒 ",
			F1 = "󱊫",
			F2 = "󱊬",
			F3 = "󱊭",
			F4 = "󱊮",
			F5 = "󱊯",
			F6 = "󱊰",
			F7 = "󱊱",
			F8 = "󱊲",
			F9 = "󱊳",
			F10 = "󱊴",
			F11 = "󱊵",
			F12 = "󱊶",
		},
	},
})

wk.add({
	-- Leader key mappings
	{ "<leader>q", ":wqa<CR>", desc = "Save all and quit", mode = "n" },
	{ "<leader>C", desc = "Toggle floating terminal", mode = "n" },

	-- Search group
	{ "<leader>s", group = "Search" },
	{ "<leader>sh", desc = "Search Help" },
	{ "<leader>sk", desc = "Search Keymaps" },
	{ "<leader>sf", desc = "Search Files" },
	{ "<leader>st", desc = "Search Select Telescope" },
	{ "<leader>sw", desc = "Search current Word" },
	{ "<leader>sg", desc = "Search by Grep" },
	{ "<leader>sd", desc = "Search Diagnostics" },
	{ "<leader>sr", desc = "Search Resume" },
	{ "<leader>s.", desc = "Search Recent Files" },
	{ "<leader>s/", desc = "Search in Open Files" },
	{ "<leader>sn", desc = "Search Neovim files" },

	-- Toggle group (moved to capital T to avoid conflict with testing)
	{ "<leader>T", group = "Toggle" },
	{ "<leader>Tc", desc = "Toggle Colorizer" },
	{ "<leader>Te", desc = "Toggle CSV view" },
	{ "<leader>Td", desc = "Dismiss All Notifications" },
	{ "<leader>Tr", desc = "Custom Search & Replace" },

	-- File group
	{ "<leader>f", group = "File" },
	{ "<leader>fr", desc = "Rename Current File" },
	{ "<leader>fm", desc = "Toggle code minimap" },

	-- Buffer group
	{ "<leader>1", desc = "Go to buffer 1" },
	{ "<leader>2", desc = "Go to buffer 2" },
	{ "<leader>3", desc = "Go to buffer 3" },
	{ "<leader>n", desc = "Next buffer" },
	{ "<leader>p", desc = "Previous buffer" },
	{ "<leader>x", desc = "Delete buffer" },
	{ "<Space><Space>", desc = "Toggle previous buffer" },

	-- Git group
	{ "<leader>g", group = "Git" },
	{ "<leader>gb", desc = "Git Blame line" },
	{ "<leader>gB", desc = "Git Browse" },
	{ "<leader>gi", group = "Git Issues" },
	{ "<leader>gil", desc = "Octo issue list" },
	{ "<leader>gic", desc = "Octo issue create" },
	{ "<leader>gis", desc = "Octo issue search" },

	-- Obsidian group
	{ "<leader>o", group = "Obsidian" },
	{ "<leader>on", desc = "Create a new note" },
	{ "<leader>oo", desc = "Opens note in obsidian" },
	{ "<leader>of", desc = "Search Vault Files" },
	{ "<leader>og", desc = "Grep Vault" },
	{ "<leader>-", desc = "Create checkbox" },

	-- Markdown group
	{ "<leader>m", group = "Markdown" },
	{ "<leader>mr", desc = "Toggle Rendering" },
	{ "<leader>me", desc = "Enable rendering" },
	{ "<leader>md", desc = "Disable rendering" },

	-- Debug group - Enhanced
	{ "<leader>d", group = "Debug" },
	{ "<leader>db", desc = "Toggle Breakpoint" },
	{ "<leader>dB", desc = "Conditional Breakpoint" },
	{ "<leader>dc", desc = "Continue" },
	{ "<leader>dl", desc = "Launch main.py" },
	{ "<leader>dr", desc = "Open REPL" },
	{ "<leader>ds", desc = "Step over" },
	{ "<leader>di", desc = "Step into" },
	{ "<leader>do", desc = "Step out" },
	{ "<leader>dh", desc = "Step back (history)" },
	{ "<leader>dx", desc = "Terminate (exit)" },
	{ "<leader>dR", desc = "Run to cursor" },
	{ "<leader>du", desc = "Toggle UI" },
	{ "<leader>de", desc = "Eval expression" },
	{ "<leader>dm", desc = "Debug test method" },
	{ "<leader>df", desc = "Debug test class (file)" },
	{ "<leader>dS", desc = "Debug selection" },
	{ "<leader>dw", desc = "Debug Web (SvelteKit dev)" },
	{ "<leader>dW", desc = "Debug Web (SvelteKit build)" },

	-- Test group
	{ "<leader>t", group = "Test" },
	{ "<leader>tt", desc = "Run all tests (make test)" },
	{ "<leader>tc", desc = "Run coverage (make coverage)" },
	{ "<leader>tC", desc = "Run tests + coverage" },
	{ "<leader>tj", desc = "Generate coverage JSON" },
	{ "<leader>tf", desc = "Run current file tests" },
	{ "<leader>tm", desc = "Run current method/test" },
	{ "<leader>tn", desc = "Run nearest test (neotest)" },
	{ "<leader>tF", desc = "Run current file (neotest)" },
	{ "<leader>ts", desc = "Toggle summary (neotest)" },
	{ "<leader>to", desc = "Show output (neotest)" },
	{ "<leader>tO", desc = "Toggle output panel (neotest)" },

	-- Coverage group
	{ "<leader>c", group = "Coverage" },
	{ "<leader>cc", desc = "Load/refresh coverage" },
	{ "<leader>cs", desc = "Show summary" },
	{ "<leader>ct", desc = "Toggle display" },
	{ "<leader>ch", desc = "Hide display" },
	{ "<leader>cl", desc = "Show/load display" },

	-- Web Development group (2025)
	{ "<leader>w", group = "Web Development" },
	{ "<leader>wr", desc = "Switch to related file (SvelteKit)" },
	{ "<leader>wR", desc = "Open related file in split" },
	{ "<leader>wt", desc = "Sort Tailwind classes" },
	{ "<leader>wb", desc = "Format with Biome" },
	{ "<leader>wp", desc = "Format with Prettier" },

	-- Lazygit
	{ "<leader>lg", desc = "Open Lazygit" },

	-- Diagnostics
	{ "<leader>e", desc = "Show diagnostic Error messages" },
	{ "[d", desc = "Go to previous Diagnostic message" },
	{ "]d", desc = "Go to next Diagnostic message" },

	-- Other keybinds
	{ "<Esc>", desc = "Clear search highlights" },
	{ "yp", desc = "Duplicate line" },
	{ "<C-b>", desc = "Jump back in jump list" },
	{ "<C-f>", desc = "Jump forward in jump list" },
	{ "<C-i>", desc = "Increment number under cursor" },
	{ "<C-a>", desc = "Select entire buffer" },
	{ "<C-o>", desc = "Insert a new line after" },
	{ "<C-e>", desc = "Window command prefix" },
	{ ":", desc = "Command line (FineCmdline)" },
	{ "/", desc = "Fuzzily search in current buffer" },
	{ "-", desc = "Open parent directory (Oil)" },

	-- Buffer navigation
	{ "[b", desc = "Previous buffer" },
	{ "b]", desc = "Next buffer" },

	-- Visual mode indentation
	{ ",", desc = "Indent left", mode = "x" },
	{ ".", desc = "Indent right", mode = "x" },

	-- Insert mode
	{ "<C-o>", desc = "Insert a new line after", mode = "i" },
})

-- Add more default Neovim keybinds for better discoverability
wk.add({
	-- Motion and navigation
	{ "gg", desc = "Go to first line" },
	{ "G", desc = "Go to last line" },
	{ "0", desc = "Go to beginning of line" },
	{ "$", desc = "Go to end of line" },
	{ "^", desc = "Go to first non-blank character" },
	{ "w", desc = "Next word" },
	{ "b", desc = "Previous word" },
	{ "e", desc = "End of word" },
	{ "f", desc = "Find character forward" },
	{ "F", desc = "Find character backward" },
	{ "t", desc = "Till character forward" },
	{ "T", desc = "Till character backward" },
	{ ";", desc = "Repeat f/t forward" },
	{ ",", desc = "Repeat f/t backward", mode = "n" },
	{ "%", desc = "Jump to matching bracket" },
	{ "*", desc = "Search word under cursor forward" },
	{ "#", desc = "Search word under cursor backward" },
	{ "n", desc = "Next search result" },
	{ "N", desc = "Previous search result" },

	-- LSP navigation (these get overridden by LSP when attached)
	{ "gd", desc = "Goto Definition (LSP)" },
	{ "gD", desc = "Goto Declaration (LSP)" },
	{ "gr", desc = "Goto References (LSP)" },
	{ "gI", desc = "Goto Implementation (LSP)" },
	{ "K", desc = "Hover Documentation (LSP)" },

	-- Text objects and operations
	{ "d", group = "Delete" },
	{ "dd", desc = "Delete line" },
	{ "dw", desc = "Delete word" },
	{ "d$", desc = "Delete to end of line" },
	{ "d0", desc = "Delete to beginning of line" },
	{ "y", group = "Yank (copy)" },
	{ "yy", desc = "Yank line" },
	{ "yw", desc = "Yank word" },
	{ "y$", desc = "Yank to end of line" },
	{ "y0", desc = "Yank to beginning of line" },
	{ "p", desc = "Paste after cursor" },
	{ "P", desc = "Paste before cursor" },
	{ "c", group = "Change" },
	{ "cc", desc = "Change line" },
	{ "cw", desc = "Change word" },
	{ "c$", desc = "Change to end of line" },
	{ "u", desc = "Undo" },
	{ "<C-r>", desc = "Redo" },
	{ ".", desc = "Repeat last command" },

	-- Visual mode
	{ "v", desc = "Visual mode" },
	{ "V", desc = "Visual line mode" },
	{ "<C-v>", desc = "Visual block mode" },

	-- Search and replace
	{ "?", desc = "Search backward" },
	{ "r", desc = "Replace character" },
	{ "R", desc = "Replace mode" },
	{ "s", desc = "Substitute character" },
	{ "S", desc = "Substitute line" },

	-- Windows and splits
	{ "<C-w>", group = "Window" },
	{ "<C-w>s", desc = "Split window horizontally" },
	{ "<C-w>v", desc = "Split window vertically" },
	{ "<C-w>c", desc = "Close window" },
	{ "<C-w>o", desc = "Close other windows" },
	{ "<C-w>h", desc = "Move to left window" },
	{ "<C-w>j", desc = "Move to window below" },
	{ "<C-w>k", desc = "Move to window above" },
	{ "<C-w>l", desc = "Move to right window" },
	{ "<C-w>=", desc = "Equalize window sizes" },
	{ "<C-w>_", desc = "Maximize window height" },
	{ "<C-w>|", desc = "Maximize window width" },

	-- Marks and jumps
	{ "m", desc = "Set mark" },
	{ "'", desc = "Jump to mark line" },
	{ "`", desc = "Jump to mark position" },

	-- Folding
	{ "za", desc = "Toggle fold" },
	{ "zA", desc = "Toggle all folds under cursor" },
	{ "zo", desc = "Open fold" },
	{ "zO", desc = "Open all folds under cursor" },
	{ "zc", desc = "Close fold" },
	{ "zC", desc = "Close all folds under cursor" },
	{ "zM", desc = "Close all folds" },
	{ "zR", desc = "Open all folds" },

	-- Insert mode shortcuts
	{ "<C-n>", desc = "Next completion", mode = "i" },
	{ "<C-p>", desc = "Previous completion", mode = "i" },
	{ "<C-x><C-f>", desc = "File completion", mode = "i" },
	{ "<C-x><C-l>", desc = "Line completion", mode = "i" },
	{ "<C-x><C-o>", desc = "Omni completion", mode = "i" },

	-- Note: : is mapped to FineCmdline
	{ "!", desc = "External command" },
	{ "q:", desc = "Command history" },
	{ "q/", desc = "Search history" },
})