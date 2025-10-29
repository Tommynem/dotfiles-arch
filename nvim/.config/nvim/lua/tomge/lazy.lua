local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

	-- == SINGLE-LINE PLUGINS ==
	-- "mg979/vim-visual-multi", -- multi-cursor, unused
	"tpope/vim-sleuth", -- auto indentation
	"numToStr/Comment.nvim", -- e.g. gc mapping
	"mfussenegger/nvim-dap", -- debug adapter protocol for nvim
	-- "hrsh7th/cmp-nvim-lsp", -- Removed: using blink.cmp instead
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("tomge.plugins.lualine")
		end,
	},
	-- "octaltree/cmp-look",
	{
		"catppuccin/nvim",

		name = "catppuccin",
		priority = 1000,

		config = function()
			require("tomge.plugins.catppuccin")
		end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,

		config = function()
			require("tomge.plugins.rose-pine")
		end,
	},
	-- "f3fora/cmp-spell", -- Removed: blink.cmp handles spell checking natively
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	}, -- nicer debugging UI
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	{
		"greggh/claude-code.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required for git operations
		},
		config = function()
			require("claude-code").setup()
		end,
	},

	-- == SEPARATED OUT PLUGINS (require minimal stubs here) ==
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = {
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
		},
		config = function()
			require("tomge.plugins.dap_python")
		end,
	},
	{
		"pwntester/octo.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("tomge.plugins.octo")
		end,
	},
	-- {
	-- 	"epwalsh/obsidian.nvim",
	-- 	lazy = false,
	-- 	ft = "markdown",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-telescope/telescope.nvim",
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 	},
	-- 	config = function()
	-- 		require("tomge.plugins.obsidian")
	-- 	end,
	-- },
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "markdown", "md" },
		config = function()
			require("tomge.plugins.render_markdown").setup()
		end,
	},
	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tomge.plugins.snacks").setup()
		end,
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
		config = function()
			require("tomge.plugins.bufferline")
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("tomge.plugins.autopairs")
		end,
	},
	{
		"VonHeikemen/fine-cmdline.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		config = function()
			require("tomge.plugins.fine_cmdline")
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("tomge.plugins.gitsigns")
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("tomge.plugins.whichkey")
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		version = "^2",
		config = function()
			require("tomge.plugins.toggleterm")
		end,
	},
	{
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("tomge.plugins.colorizer")
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		version = "0.2.*",  -- Required for nvim-treesitter 1.0 compatibility
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("tomge.plugins.telescope")
		end,
	},
	{
		"rmagatti/auto-session",
		lazy = false,
		config = function()
			require("tomge.plugins.auto_session")
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			{ "folke/neodev.nvim", opts = {} },
		},
		config = function()
			require("tomge.plugins.lspconfig")
		end,
	},
	{
		"stevearc/conform.nvim",
		lazy = false,
		config = function()
			require("tomge.plugins.conform")
		end,
	},
	{
		"hat0uma/csvview.nvim",
		config = function()
			require("tomge.plugins.csvview")
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			require("tomge.plugins.indent_blankline")
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("tomge.plugins.todo_comments")
		end,
	},
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("tomge.plugins.nvim_surround")
		end,
	},
	{
		"echasnovski/mini.nvim",
		config = function()
			require("tomge.plugins.mini")
		end,
	},
	{
		"stevearc/oil.nvim",
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		config = function()
			require("tomge.plugins.oil")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		priority = 900,  -- Load before telescope and other plugins that depend on it
		build = ":TSUpdate",
		config = function()
			require("tomge.plugins.treesitter")
		end,
	},
	require("tomge.plugins.python"),
	{
		"andythigpen/nvim-coverage",
		ft = "python",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("tomge.plugins.coverage").setup()
		end,
	},
	-- Modern Web Development Plugins (2025)
	{
		"luckasRanarison/tailwind-tools.nvim",
		name = "tailwind-tools",
		build = ":UpdateRemotePlugins",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
			"neovim/nvim-lspconfig",
		},
		ft = { "html", "css", "scss", "javascript", "typescript", "jsx", "tsx", "svelte", "vue", "astro" },
		config = function()
			require("tailwind-tools").setup({
				document_color = {
					enabled = true,
					kind = "inline",
					inline_symbol = "󰝤 ",
					debounce = 200,
				},
				conceal = {
					enabled = false,
					min_length = nil,
					symbol = "󱏿",
					highlight = {
						fg = "#38BDF8",
					},
				},
				custom_filetypes = { "svelte" },
			})
		end,
	},
	-- Visual Enhancement Plugins (2025)
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		config = function()
			require("tomge.plugins.luasnip")
		end,
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"L3MON4D3/LuaSnip",
		},
		version = "*",
		config = function()
			require("tomge.plugins.blink_cmp")
		end,
	},
	{
		"nvim-zh/colorful-winsep.nvim",
		config = function()
			require("colorful-winsep").setup({
				-- Updated API: no longer uses table format for highlight
				hi = {
					bg = "#1e1e2e", -- catppuccin base
					fg = "#cba6f7", -- catppuccin mauve
				},
				interval = 30,
				no_exec_files = { "packer", "TelescopePrompt", "mason", "CompetiTest", "NvimTree" },
			})
		end,
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		config = function()
			local rainbow_delimiters = require("rainbow-delimiters")
			require("rainbow-delimiters.setup").setup({
				strategy = {
					[""] = rainbow_delimiters.strategy["global"],
					vim = rainbow_delimiters.strategy["local"],
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
				},
				priority = {
					[""] = 110,
					lua = 210,
				},
				highlight = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
			})
		end,
	},
	{
		"rasulomaroff/reactive.nvim",
		config = function()
			require("reactive").setup({
				builtin = {
					cursorline = true,
					cursor = true,
					modemsg = true,
				},
				-- Catppuccin theme integration
				load = { "catppuccin-mocha-cursor", "catppuccin-mocha-cursorline" },
			})
		end,
	},
	{
		"RRethy/vim-illuminate",
		config = function()
			require("illuminate").configure({
				providers = {
					"lsp",
					"treesitter",
					"regex",
				},
				delay = 100,
				filetype_overrides = {},
				filetypes_denylist = {
					"dirbuf",
					"dirvish",
					"fugitive",
				},
				filetypes_allowlist = {},
				modes_denylist = {},
				modes_allowlist = {},
				providers_regex_syntax_denylist = {},
				providers_regex_syntax_allowlist = {},
				under_cursor = true,
				large_file_cutoff = nil,
				large_file_overrides = nil,
				min_count_to_highlight = 1,
				should_enable = function(bufnr)
					return true
				end,
				case_insensitive_regex = false,
			})
		end,
	},
	{
		"shellRaining/hlchunk.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("hlchunk").setup({
				chunk = {
					enable = true,
					priority = 15,
					style = {
						{ fg = "#806d9c" },
						{ fg = "#c21f30" },
					},
					use_treesitter = true,
					chars = {
						horizontal_line = "─",
						vertical_line = "│",
						left_top = "╭",
						left_bottom = "╰",
						right_arrow = ">",
					},
					textobject = "",
					max_file_size = 1024 * 1024,
					error_sign = true,
				},
				indent = {
					enable = false, -- Disable since we have indent-blankline
				},
				line_num = {
					enable = false,
				},
				blank = {
					enable = false,
				},
			})
		end,
	},
	{
		"chentoast/marks.nvim",
		config = function()
			require("marks").setup({
				default_mappings = true,
				builtin_marks = { ".", "<", ">", "^" },
				cyclic = true,
				force_write_shada = false,
				refresh_interval = 250,
				sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
				excluded_filetypes = {},
				excluded_buftypes = { "nofile" },
				bookmark_0 = {
					sign = "⚑",
					virt_text = "hello world",
					annotate = false,
				},
				mappings = {},
			})
		end,
	},
	{
		"rgroli/other.nvim",
		config = function()
			require("other-nvim").setup({
				mappings = {
					-- SvelteKit file mappings
					{
						pattern = "/src/routes/(.*)/+page.svelte$",
						target = "/src/routes/%1/+page.server.ts",
						context = "server",
					},
					{
						pattern = "/src/routes/(.*)/+page.server.ts$",
						target = "/src/routes/%1/+page.svelte",
						context = "component",
					},
					{
						pattern = "/src/routes/(.*)/+layout.svelte$",
						target = "/src/routes/%1/+layout.server.ts",
						context = "server",
					},
					{
						pattern = "/src/routes/(.*)/+layout.server.ts$",
						target = "/src/routes/%1/+layout.svelte",
						context = "component",
					},
					-- Component mappings
					{
						pattern = "/src/lib/components/(.*).svelte$",
						target = "/src/lib/components/%1.test.ts",
						context = "test",
					},
					{
						pattern = "/src/lib/components/(.*).test.ts$",
						target = "/src/lib/components/%1.svelte",
						context = "component",
					},
				},
			})
		end,
	},
	{
		"b0o/schemastore.nvim",
		ft = { "json", "jsonc" },
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
		},
		ft = { "javascript", "typescript", "svelte", "vue", "astro", "jsx", "tsx" },
		config = function()
			require("tomge.plugins.dap_web")
		end,
	},
	{
		"windwp/nvim-ts-autotag",
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-python",
		},
		lazy = true,
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python")({
						dap = { justMyCode = false },
						args = { "--log-level", "DEBUG" },
						runner = "pytest",
					}),
				},
			})
		end,
	},
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
