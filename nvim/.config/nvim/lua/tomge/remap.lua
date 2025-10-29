-- Custom or unsorted

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.hlsearch = true
vim.api.nvim_set_keymap("n", "<Leader>q", ":wqa<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("n", "yp", "yyp", { desc = "Duplicate line" })
-- [b]ack in jump list
vim.keymap.set("n", "<C-b>", "<C-o>", { noremap = true, silent = true, desc = "Jump back in jump list" })
-- [f]orward in jump list
vim.keymap.set("n", "<C-f>", "<C-i>", { noremap = true, silent = true, desc = "Jump forward in jump list" })
-- increment next number
vim.keymap.set("n", "<C-i>", "<C-a>", { noremap = true, silent = true, desc = "Increment number under the cursor" })

vim.keymap.set(
	"n",
	"<C-a>",
	":keepjumps normal! ggVG<CR>",
	{ noremap = true, silent = true, desc = "Select entire buffer without affecting jump list" }
)

pcall(vim.keymap.del, "n", "<C-o>")
pcall(vim.keymap.del, "i", "<C-o>")

vim.keymap.set("n", "<C-o>", "o<Esc>", { noremap = true, silent = true, desc = "Insert a new line after" })
vim.keymap.set(
	"i",
	"<C-o>",
	"<Esc>o",
	{ noremap = true, silent = true, desc = "Insert a new line after (insert mode)" }
)

vim.keymap.set("n", "<C-e>", "<C-w>", { noremap = true, silent = true })

-- FineCmdline keybinding
vim.api.nvim_set_keymap("n", ":", "<cmd>FineCmdline<CR>", { silent = true })

-- Floating terminal keybinding
vim.api.nvim_set_keymap("n", "<leader>C", "<cmd>lua _FLOAT_TERM_TOGGLE()<CR>", {noremap = true, silent = true, desc = "Toggle floating terminal"})

-- Toggle Colorizer (moved to avoid conflict with testing)
vim.api.nvim_set_keymap(
	"n",
	"<leader>Tc",
	"<cmd>ColorizerToggle<CR>",
	{ noremap = true, silent = true, desc = "Toggle Colorizer" }
)

-- Telescope
require("telescope").setup({})
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>st", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

vim.keymap.set("n", "/", function()
	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>s/", function()
	builtin.live_grep({
		grep_open_files = true,
		prompt_title = "Live Grep in Open Files",
	})
end, { desc = "[S]earch [/] in Open Files" })

local telescope = require("telescope.builtin")
-- Search for files in the vault
vim.keymap.set("n", "<leader>of", function()
	telescope.find_files({
		prompt_title = "Search Vault Files",
		cwd = vim.env.OBSIDIAN_VAULT_PATH or vim.fn.expand("~/Documents/ObsidianVault"),
	})
end, { desc = "Search Vault Files" })

-- Search for text using grep in the vault
vim.keymap.set("n", "<leader>og", function()
	telescope.live_grep({
		prompt_title = "Grep Vault",
		cwd = vim.env.OBSIDIAN_VAULT_PATH or vim.fn.expand("~/Documents/ObsidianVault"),
	})
end, { desc = "Grep Vault" })
-- Neovim config search shortcut
vim.keymap.set("n", "<leader>sn", function()
	builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })

-- Diagnostics mappings
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })

-- Custom Keymaps (moved to avoid conflict with testing)
vim.api.nvim_set_keymap("n", "<leader>Te", ":CsvViewToggle", { desc = "[T]oggle csv view" })

-- Custom replace ui (moved to avoid conflict with testing)
vim.keymap.set("n", "<leader>Tr", function()
	local snacks = require("snacks")

	-- 1. Prompt for "Search text"
	snacks.input({
		prompt = "Search text: ",
		icon = " ",
	}, function(old)
		if not old or old == "" then
			-- User canceled or empty input
			return
		end

		-- 2. Prompt for "Replace text"
		snacks.input({
			prompt = "Replace text: ",
			icon = " ",
		}, function(new)
			if new == nil then
				-- Canceled
				return
			end

			-- 3. Execute the :%s command
			-- g = global
			-- c = confirm on each occurrence
			--
			-- NOTE: This is a naive approach that doesn't escape
			-- special regex characters. If 'old' or 'new' contain
			-- '/', it may break. For a robust solution, consider
			-- escaping or using a literal search mode.
			local cmd = string.format("%%s/%s/%s/gc", old, new)
			vim.cmd(cmd)
		end)
	end)
end, { desc = "Custom Search & Replace with snacks.input" })

-- Bufferline
vim.api.nvim_set_keymap(
	"n",
	"[b",
	":BufferLineCyclePrev<CR>",
	{ noremap = true, silent = true, desc = "Previous buffer" }
)
vim.api.nvim_set_keymap("n", "b]", ":BufferLineCycleNext<CR>", { noremap = true, silent = true, desc = "Next buffer" })

-- Bufferline specific jumps
vim.api.nvim_set_keymap(
	"n",
	"<leader>1",
	"<Cmd>BufferLineGoToBuffer 1<CR>",
	{ noremap = true, silent = true, desc = "Go to buffer 1" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>2",
	"<Cmd>BufferLineGoToBuffer 2<CR>",
	{ noremap = true, silent = true, desc = "Go to buffer 2" }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>3",
	"<Cmd>BufferLineGoToBuffer 3<CR>",
	{ noremap = true, silent = true, desc = "Go to buffer 3" }
)

-- Buffer manipulation
vim.api.nvim_set_keymap("n", "<leader>n", ":bn<CR>", { noremap = true, silent = true, desc = "Next buffer" })
vim.api.nvim_set_keymap("n", "<leader>p", ":bp<CR>", { noremap = true, silent = true, desc = "Previous buffer" })
-- vim.api.nvim_set_keymap("n", "<leader>x", ":bd<CR>", { noremap = true, silent = true, desc = "Close buffer" })

-- Toggle buffers
vim.api.nvim_set_keymap(
	"n",
	"<Space><Space>",
	"<C-^>",
	{ noremap = true, silent = true, desc = "Toggle previous buffer" }
)

-- Indentation in visual mode
vim.api.nvim_set_keymap("x", ",", "<gv", { noremap = true, silent = true, desc = "Indent left" })
vim.api.nvim_set_keymap("x", ".", ">gv", { noremap = true, silent = true, desc = "Indent right" })

-- Oil file explorer
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Obsidian
vim.keymap.set("n", "<leader>on", ":ObsidianNew<CR>", { desc = "Create a new note" })
vim.keymap.set("n", "<leader>oo", ":ObsidianOpen<CR>", { desc = "Opens the current note in obsidian" })
vim.keymap.set("n", "<leader>-", "i- [ ]<ESC>A", { desc = "Opens the current note in obsidian" })

-- Markdown Rendering (render-markdown.nvim)
vim.keymap.set("n", "<leader>mr", function()
	require("render-markdown").toggle()
end, { desc = "[M]arkdown: Toggle [R]endering" })

vim.keymap.set("n", "<leader>me", function()
	require("render-markdown").enable()
end, { desc = "[M]arkdown: [E]nable rendering" })

vim.keymap.set("n", "<leader>md", function()
	require("render-markdown").disable()
end, { desc = "[M]arkdown: [D]isable rendering" })

-- Debugging - Enhanced
local dap = require("dap")
local dapui = require("dapui")

-- Basic debugging controls
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "[D]AP: Toggle [B]reakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "[D]AP: [C]ontinue" })
vim.keymap.set("n", "<leader>dl", function()
	dap.run(dap.configurations.python[1])
end, { desc = "[D]AP: [L]aunch main.py" })

-- Advanced debugging controls
vim.keymap.set("n", "<leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "[D]AP: Conditional [B]reakpoint" })

vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "[D]AP: Open [R]EPL" })
vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "[D]AP: [S]tep over" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "[D]AP: Step [I]nto" })
vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "[D]AP: Step [O]ut" })
vim.keymap.set("n", "<leader>dh", dap.step_back, { desc = "[D]AP: Step Back ([H]istory)" })
vim.keymap.set("n", "<leader>dx", dap.terminate, { desc = "[D]AP: Terminate (e[X]it)" })
vim.keymap.set("n", "<leader>dR", dap.run_to_cursor, { desc = "[D]AP: [R]un to cursor" })

-- DAP UI controls
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "[D]AP: Toggle [U]I" })
vim.keymap.set("n", "<leader>de", dapui.eval, { desc = "[D]AP: [E]val expression" })
vim.keymap.set("v", "<leader>de", dapui.eval, { desc = "[D]AP: [E]val selection" })

-- Python-specific debugging
vim.keymap.set("n", "<leader>dm", function()
	require("dap-python").test_method()
end, { desc = "[D]AP: Debug test [M]ethod" })

vim.keymap.set("n", "<leader>df", function()
	require("dap-python").test_class()
end, { desc = "[D]AP: Debug test class ([F]ile)" })

vim.keymap.set("n", "<leader>dS", function()
	require("dap-python").debug_selection()
end, { desc = "[D]AP: Debug [S]election" })

-- snacks keymaps
local ok, snacks = pcall(require, "snacks")
if not ok then
	return
end

local map = vim.keymap.set

-- Git Browse: open the current file/branch in your web browser
map("n", "<leader>gB", function()
	snacks.gitbrowse()
end, { desc = "Git Browse (current file/branch)" })

map("n", "<leader>lg", function()
	snacks.lazygit()
end, { desc = "Open Lazygit" })
-- Git blame the current line
map("n", "<leader>gb", function()
	snacks.git.blame_line()
end, { desc = "Git Blame line" })

-- Dismiss all notifications (moved to avoid conflict with testing)
map("n", "<leader>Td", function()
	snacks.notifier.hide()
end, { desc = "Dismiss All Notifications" })

-- Rename Current File (with LSP support)
map("n", "<leader>fr", function()
	snacks.rename.rename_file()
end, { desc = "Rename Current File (snacks.rename)" })

local has_mini_bufremove, mini_bufremove = pcall(require, "mini.bufremove")
local has_mini_map, mini_map = pcall(require, "mini.map")

-- mini.nvim
if has_mini_bufremove then
	map("n", "<leader>x", function()
		mini_bufremove.delete(0, false) -- current buffer, force=false
	end, { desc = "[B]uffer [D]elete (mini.bufremove)" })
end

if has_mini_map then
	-- Toggle the code minimap
	map("n", "<leader>fm", function()
		if mini_map.auto_enabled then
			mini_map.close()
			mini_map.auto_enabled = false
		else
			mini_map.open()
			mini_map.auto_enabled = true
		end
	end, { desc = "Toggle code minimap (mini.map)" })
end


map("n", "<leader>gil", ":Octo issue list<CR>")
map("n", "<leader>gic", ":Octo issue create<CR>")
map("n", "<leader>gis", ":Octo issue search<CR>")

-- Testing and Coverage keybindings
-- Note: testing functions are loaded lazily to avoid circular dependencies

-- Core testing commands
vim.keymap.set("n", "<leader>tt", function()
	require("tomge.plugins.testing").run_tests()
end, { desc = "[T]est: Run all [T]ests (make test)" })

vim.keymap.set("n", "<leader>tc", function()
	require("tomge.plugins.testing").run_coverage()
end, { desc = "[T]est: Run [C]overage (make coverage)" })

vim.keymap.set("n", "<leader>tC", function()
	require("tomge.plugins.testing").run_test_coverage()
end, { desc = "[T]est: Run tests + [C]overage" })

vim.keymap.set("n", "<leader>tj", function()
	require("tomge.plugins.testing").generate_coverage_json()
end, { desc = "[T]est: Generate coverage [J]SON" })

-- File-specific testing
vim.keymap.set("n", "<leader>tf", function()
	require("tomge.plugins.testing").run_current_file_tests()
end, { desc = "[T]est: Run current [F]ile tests" })

vim.keymap.set("n", "<leader>tm", function()
	require("tomge.plugins.testing").run_current_test()
end, { desc = "[T]est: Run current [M]ethod/test" })

-- Neotest integration
vim.keymap.set("n", "<leader>tn", function()
	require("neotest").run.run()
end, { desc = "[T]est: Run [N]earest test (neotest)" })

vim.keymap.set("n", "<leader>tF", function()
	require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "[T]est: Run current [F]ile (neotest)" })

vim.keymap.set("n", "<leader>ts", function()
	require("neotest").summary.toggle()
end, { desc = "[T]est: Toggle [S]ummary (neotest)" })

vim.keymap.set("n", "<leader>to", function()
	require("neotest").output.open({ enter = true })
end, { desc = "[T]est: Show [O]utput (neotest)" })

vim.keymap.set("n", "<leader>tO", function()
	require("neotest").output_panel.toggle()
end, { desc = "[T]est: Toggle [O]utput panel (neotest)" })

-- Coverage display commands
vim.keymap.set("n", "<leader>cc", function()
	require("coverage").load(true)
end, { desc = "[C]overage: Load/refresh [C]overage" })

vim.keymap.set("n", "<leader>cs", function()
	require("coverage").summary()
end, { desc = "[C]overage: Show [S]ummary" })

vim.keymap.set("n", "<leader>ct", function()
	require("coverage").toggle()
end, { desc = "[C]overage: [T]oggle display" })

vim.keymap.set("n", "<leader>ch", function()
	require("coverage").hide()
end, { desc = "[C]overage: [H]ide display" })

vim.keymap.set("n", "<leader>cl", function()
	require("coverage").show()
end, { desc = "[C]overage: Show/[L]oad display" })

-- Web Development Specific Keybindings (2025)

-- SvelteKit file switching (other.nvim)
vim.keymap.set("n", "<leader>wr", function()
	require("other-nvim").open()
end, { desc = "[W]eb: Switch to [R]elated file (SvelteKit)" })

vim.keymap.set("n", "<leader>wR", function()
	require("other-nvim").openVSplit()
end, { desc = "[W]eb: Open [R]elated file in split" })

-- Tailwind Tools
vim.keymap.set("n", "<leader>wt", function()
	require("tailwind-tools").sort_selection()
end, { desc = "[W]eb: Sort [T]ailwind classes" })

vim.keymap.set("v", "<leader>wt", function()
	require("tailwind-tools").sort_selection()
end, { desc = "[W]eb: Sort [T]ailwind classes" })

-- Web debugging keybindings (JavaScript/SvelteKit)
vim.keymap.set("n", "<leader>dw", function()
	local dap = require("dap")
	-- Start SvelteKit dev server debugging
	dap.run(dap.configurations.typescript[1])
end, { desc = "[D]AP: Debug [W]eb (SvelteKit dev)" })

vim.keymap.set("n", "<leader>dW", function()
	local dap = require("dap")
	-- Debug SvelteKit build
	dap.run(dap.configurations.typescript[2])
end, { desc = "[D]AP: Debug [W]eb (SvelteKit build)" })

-- Enhanced formatting for web files
vim.keymap.set("n", "<leader>wb", function()
	local conform = require("conform")
	conform.format({
		formatters = { "biome" },
		async = true,
	})
end, { desc = "[W]eb: Format with [B]iome" })

vim.keymap.set("n", "<leader>wp", function()
	local conform = require("conform")
	conform.format({
		formatters = { "prettier" },
		async = true,
	})
end, { desc = "[W]eb: Format with [P]rettier" })
