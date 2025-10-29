-- Theme Switcher: Automatically detects and applies Omarchy theme to Neovim
-- Reads from: ~/.config/omarchy/current/theme/neovim.lua
-- Falls back to system color scheme preference if Omarchy config not found

local M = {}

function M.detect_and_apply_theme()
	local omarchy_theme_file = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")

	-- Check if Omarchy theme config exists
	if vim.fn.filereadable(omarchy_theme_file) == 1 then
		-- Load the Omarchy theme config
		local ok, theme_config = pcall(dofile, omarchy_theme_file)

		if ok and theme_config then
			-- Extract colorscheme from LazyVim opts
			for _, plugin in ipairs(theme_config) do
				if plugin.opts and plugin.opts.colorscheme then
					local colorscheme = plugin.opts.colorscheme

					-- Try to set the colorscheme
					local success, err = pcall(vim.cmd.colorscheme, colorscheme)
					if success then
						vim.notify("Applied Omarchy theme: " .. colorscheme, vim.log.levels.INFO)
						return true
					else
						vim.notify("Failed to apply theme " .. colorscheme .. ": " .. tostring(err), vim.log.levels.WARN)
					end
				end
			end
		end
	end

	-- Fallback: Use system preference
	local gsettings_cmd = "gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null"
	local handle = io.popen(gsettings_cmd)
	if handle then
		local result = handle:read("*a")
		handle:close()

		if result:match("prefer%-dark") then
			vim.opt.background = "dark"
			pcall(vim.cmd.colorscheme, "rose-pine-moon")
			vim.notify("Applied dark theme (system preference)", vim.log.levels.INFO)
		elseif result:match("prefer%-light") then
			vim.opt.background = "light"
			pcall(vim.cmd.colorscheme, "rose-pine-dawn")
			vim.notify("Applied light theme (system preference)", vim.log.levels.INFO)
		else
			-- Final fallback to catppuccin
			pcall(vim.cmd.colorscheme, "catppuccin")
		end
	end

	return false
end

-- Auto-detect and apply theme on startup
M.detect_and_apply_theme()

-- Create user command for manual theme refresh
vim.api.nvim_create_user_command("ThemeRefresh", function()
	M.detect_and_apply_theme()
end, { desc = "Refresh theme from Omarchy config" })

return M
