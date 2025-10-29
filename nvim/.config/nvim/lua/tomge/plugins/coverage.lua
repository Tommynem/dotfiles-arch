local M = {}

M.setup = function()
	require("coverage").setup({
		commands = true, -- create commands
		highlights = {
			-- customize highlight groups created by the plugin
			covered = { fg = "#C3E88D" }, -- green
			uncovered = { fg = "#F07178" }, -- red
		},
		signs = {
			-- use your own highlight groups or text markers
			covered = { hl = "CoverageCovered", text = "▎" },
			uncovered = { hl = "CoverageUncovered", text = "▎" },
		},
		summary = {
			-- customize the summary pop-up
			min_coverage = 80.0, -- minimum coverage threshold (used for highlighting)
		},
		lang = {
			-- customize language specific settings
			python = {
				-- set to true to enable the plugin for python files
				coverage_file = ".coverage",
				coverage_command = "coverage json --fail-under=0 -q -o -",
			},
		},
	})

	-- Set up autocommands for automatic coverage loading
	vim.api.nvim_create_augroup("Coverage", { clear = true })

	-- Auto-load coverage when entering python files (if .coverage exists)
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = "Coverage",
		pattern = "*.py",
		callback = function()
			-- Check if .coverage file exists in current working directory
			if vim.fn.filereadable(".coverage") == 1 then
				-- Small delay to ensure file is fully loaded
				vim.defer_fn(function()
					require("coverage").load(true)
				end, 100)
			end
		end,
	})

	-- Auto-reload coverage when coverage file changes
	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		group = "Coverage",
		pattern = ".coverage",
		callback = function()
			require("coverage").load(true)
		end,
	})
end

return M