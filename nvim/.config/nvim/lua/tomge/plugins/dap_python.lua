local M = {}

M.setup = function()
	local dap = require("dap")
	local dapui = require("dapui")

	-- Setup DAP UI
	dapui.setup({
		icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
		mappings = {
			expand = { "<CR>", "<2-LeftMouse>" },
			open = "o",
			remove = "d",
			edit = "e",
			repl = "r",
			toggle = "t",
		},
		expand_lines = vim.fn.has("nvim-0.7") == 1,
		layouts = {
			{
				elements = {
					{ id = "scopes", size = 0.25 },
					"breakpoints",
					"stacks",
					"watches",
				},
				size = 40,
				position = "left",
			},
			{
				elements = {
					"repl",
					"console",
				},
				size = 0.25,
				position = "bottom",
			},
		},
		controls = {
			enabled = true,
			element = "repl",
			icons = {
				pause = "",
				play = "",
				step_into = "",
				step_over = "",
				step_out = "",
				step_back = "",
				run_last = "↻",
				terminate = "□",
			},
		},
		floating = {
			max_height = nil,
			max_width = nil,
			border = "single",
			mappings = {
				close = { "q", "<Esc>" },
			},
		},
		windows = { indent = 1 },
		render = {
			max_type_length = nil,
			max_value_lines = 100,
		},
	})

	-- Python debugger setup with multiple path options
	local function get_python_path()
		-- Try to detect virtual environment
		local venv_python = vim.fn.getenv("VIRTUAL_ENV")
		if venv_python and venv_python ~= vim.NIL then
			return venv_python .. "/bin/python"
		end

		-- Try local .venv
		local cwd = vim.fn.getcwd()
		local local_venv = cwd .. "/.venv/bin/python"
		if vim.fn.executable(local_venv) == 1 then
			return local_venv
		end

		-- Try Mason-installed debugpy
		local mason_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
		if vim.fn.executable(mason_python) == 1 then
			return mason_python
		end

		-- Fallback to system python
		return "/Library/Frameworks/Python.framework/Versions/3.12/bin/python3.12"
	end

	local python_path = get_python_path()
	require("dap-python").setup(python_path)

	-- Enhanced Python configurations
	dap.configurations.python = {
		{
			type = "python",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			pythonPath = python_path,
		},
		{
			type = "python",
			request = "launch",
			name = "Launch file with arguments",
			program = "${file}",
			args = function()
				local args_string = vim.fn.input("Arguments: ")
				return vim.split(args_string, " +")
			end,
			pythonPath = python_path,
		},
		{
			type = "python",
			request = "launch",
			name = "Launch main.py",
			program = "${workspaceFolder}/main.py",
			pythonPath = python_path,
		},
		{
			type = "python",
			request = "launch",
			name = "Django",
			program = "${workspaceFolder}/manage.py",
			args = {
				"runserver",
			},
			pythonPath = python_path,
			django = true,
		},
		{
			type = "python",
			request = "launch",
			name = "Flask",
			module = "flask",
			env = {
				FLASK_APP = "app.py",
				FLASK_ENV = "development",
			},
			args = {
				"run",
				"--no-debugger",
				"--no-reload",
			},
			pythonPath = python_path,
		},
		{
			type = "python",
			request = "attach",
			name = "Attach remote",
			connect = function()
				local host = vim.fn.input("Host [127.0.0.1]: ")
				host = host ~= "" and host or "127.0.0.1"
				local port = tonumber(vim.fn.input("Port [5678]: ")) or 5678
				return { host = host, port = port }
			end,
		},
		{
			type = "python",
			request = "launch",
			name = "Run Tests",
			module = "pytest",
			args = {
				"${workspaceFolder}",
				"-v",
			},
			pythonPath = python_path,
		},
		{
			type = "python",
			request = "launch",
			name = "Run Current Test File",
			module = "pytest",
			args = {
				"${file}",
				"-v",
			},
			pythonPath = python_path,
		},
	}

	-- Auto open/close DAP UI
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end

	-- Catppuccin DAP sign integration
	vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
	vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
	vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
	vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
	vim.fn.sign_define("DapBreakpointRejected", { text = "✖", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })

	-- Configure virtual text (if available)
	local ok, dap_virtual_text = pcall(require, "nvim-dap-virtual-text")
	if ok then
		dap_virtual_text.setup({
			enabled = true,
			enabled_commands = true,
			highlight_changed_variables = true,
			highlight_new_as_changed = false,
			show_stop_reason = true,
			commented = false,
			only_first_definition = true,
			all_references = false,
			clear_on_continue = false,
			display_callback = function(variable, buf, stackframe, node, options)
				if options.virt_text_pos == "inline" then
					return " = " .. variable.value
				else
					return variable.name .. " = " .. variable.value
				end
			end,
			virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
			all_frames = false,
			virt_lines = false,
			virt_text_win_col = nil,
		})
	end
end

-- Call setup
M.setup()
