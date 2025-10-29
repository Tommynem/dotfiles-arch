local M = {}

-- Function to get Terminal class (lazy loading)
local function get_terminal()
	return require("toggleterm.terminal").Terminal
end

-- Testing terminals
local test_term = nil
local coverage_term = nil

-- Function to run tests
M.run_tests = function()
	local Terminal = get_terminal()
	if test_term then
		test_term:close()
	end
	test_term = Terminal:new({
			cmd = "make test",
			direction = "horizontal",
			size = 15,
			close_on_exit = false,
			on_open = function(term)
				vim.cmd("startinsert!")
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
			end,
		})
		test_term:open()
	end

-- Function to run coverage
M.run_coverage = function()
	local Terminal = get_terminal()
	if coverage_term then
		coverage_term:close()
	end
	coverage_term = Terminal:new({
			cmd = "make coverage",
			direction = "horizontal",
			size = 15,
			close_on_exit = false,
			on_open = function(term)
				vim.cmd("startinsert!")
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
			end,
		})
		coverage_term:open()
	end

-- Function to generate coverage for IDE integration
M.generate_coverage_json = function()
	local Terminal = get_terminal()
	local coverage_json_term = Terminal:new({
			cmd = "make coverage-json",
			direction = "horizontal",
			size = 10,
			close_on_exit = true,
			on_exit = function()
				-- Reload coverage display after generation
				vim.defer_fn(function()
					if require("coverage").is_loaded() then
						require("coverage").load(true)
					end
				end, 500)
			end,
		})
		coverage_json_term:open()
	end

-- Function to run tests and coverage in sequence
M.run_test_coverage = function()
	local Terminal = get_terminal()
	if test_term then
		test_term:close()
	end
	test_term = Terminal:new({
			cmd = "make test && make coverage-json",
			direction = "horizontal",
			size = 15,
			close_on_exit = false,
			on_open = function(term)
				vim.cmd("startinsert!")
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
			end,
			on_exit = function()
				-- Reload coverage display after tests and coverage generation
				vim.defer_fn(function()
					if require("coverage").is_loaded() then
						require("coverage").load(true)
					end
				end, 500)
			end,
		})
		test_term:open()
	end

-- Function to run pytest on current file
M.run_current_file_tests = function()
	local Terminal = get_terminal()
	local current_file = vim.fn.expand("%")
	if not vim.endswith(current_file, ".py") then
		vim.notify("Not a Python file!", vim.log.levels.WARN)
		return
	end

	local file_test_term = Terminal:new({
			cmd = "python -m pytest " .. current_file .. " -v",
			direction = "horizontal",
			size = 15,
			close_on_exit = false,
			on_open = function(term)
				vim.cmd("startinsert!")
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
			end,
		})
		file_test_term:open()
	end

-- Function to run pytest on current function/method
M.run_current_test = function()
	local Terminal = get_terminal()
	local current_file = vim.fn.expand("%")
	if not vim.endswith(current_file, ".py") then
		vim.notify("Not a Python file!", vim.log.levels.WARN)
		return
	end

	-- Get current function name (simplified - works for most cases)
	local line = vim.fn.line(".")
	local lines = vim.api.nvim_buf_get_lines(0, 0, line, false)
	local test_name = nil

	-- Look backwards for the nearest test function
	for i = #lines, 1, -1 do
		local match = lines[i]:match("^%s*def%s+(test_%w+)")
		if match then
			test_name = match
			break
		end
	end

	if not test_name then
		vim.notify("No test function found!", vim.log.levels.WARN)
		return
	end

	local current_test_term = Terminal:new({
			cmd = "python -m pytest " .. current_file .. "::" .. test_name .. " -v",
			direction = "horizontal",
			size = 15,
			close_on_exit = false,
			on_open = function(term)
				vim.cmd("startinsert!")
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
			end,
		})
		current_test_term:open()
	end

return M