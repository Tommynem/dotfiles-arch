require("catppuccin").setup({
	flavour = "auto", -- latte, frappe, macchiato, mocha
	background = { -- :h background
		light = "latte",
		dark = "mocha",
	},
	transparent_background = false, -- Use catppuccin's proper background instead of terminal/neovide background
	show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
	term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
	dim_inactive = {
		enabled = false, -- dims the background color of inactive window
		shade = "dark",
		percentage = 0.15, -- percentage of the shade to apply to the inactive window
	},
	no_italic = false, -- Force no italic
	no_bold = false, -- Force no bold
	no_underline = false, -- Force no underline
	styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
		comments = { "italic" }, -- Change the style of comments
		conditionals = { "italic" },
		loops = {},
		functions = {},
		keywords = {},
		strings = {},
		variables = {},
		numbers = {},
		booleans = {},
		properties = {},
		types = {},
		operators = {},
		-- miscs = {}, -- Uncomment to turn off hard-coded styles
	},
	color_overrides = {},
	custom_highlights = {},
	default_integrations = true,
	integrations = {
		-- Core functionality
		cmp = false, -- Disabled in favor of blink.cmp
		treesitter = true,
		semantic_tokens = true,
		markdown = true, -- For obsidian.nvim

		-- Git integration
		gitsigns = {
			enabled = true,
			transparent = false, -- Match transparent_background setting
		},

		-- Navigation and UI
		telescope = {
			enabled = true,
		},
		which_key = true, -- Enable which-key integration

		-- File management
		nvimtree = true, -- Keep for compatibility

		-- Editing enhancements
		mini = {
			enabled = true,
			indentscope_color = "lavender", -- Use catppuccin lavender for scope
		},
		nvim_surround = true,
		indent_blankline = {
			enabled = true,
			scope_color = "lavender", -- Match mini indentscope
			colored_indent_levels = false,
		},

		-- Development tools
		native_lsp = {
			enabled = true,
			virtual_text = {
				errors = { "italic" },
				hints = { "italic" },
				warnings = { "italic" },
				information = { "italic" },
				ok = { "italic" },
			},
			underlines = {
				errors = { "underline" },
				hints = { "underline" },
				warnings = { "underline" },
				information = { "underline" },
				ok = { "underline" },
			},
			inlay_hints = {
				background = true,
			},
		},
		mason = true, -- Enable mason integration
		fidget = true, -- Enable fidget integration for LSP progress

		-- Debugging
		dap = true,
		dap_ui = true,

		-- Testing
		neotest = true,

		-- GitHub integration
		octo = true,

		-- Notification system (snacks.nvim)
		snacks = {
			enabled = true,
			indent_scope_color = "lavender",
		},

		-- Visual Enhancement Plugins (2025)
		blink_cmp = {
			style = "bordered", -- Modern completion styling
		},
		colorful_winsep = {
			enabled = true,
			color = "mauve", -- Use catppuccin mauve for window separators
		},
		rainbow_delimiters = true, -- Rainbow bracket pairs
		illuminate = {
			enabled = true,
			lsp = false, -- We have LSP integration separately
		},

		-- Disable unused integrations
		notify = false, -- Using snacks notifications instead
	},
})

-- setup must be called before loading
vim.cmd.colorscheme("catppuccin")
