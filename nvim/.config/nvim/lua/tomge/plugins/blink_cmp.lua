-- saghen/blink.cmp - Modern completion engine with refined configuration for natural behavior
require("blink.cmp").setup({
	-- Keymap configuration
	keymap = {
		preset = "default",
		-- Custom keymaps for snippet expansion
		["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },
	},

	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "mono",
	},

	-- Snippets configuration - new system for LuaSnip integration
	snippets = {
		preset = "luasnip",
	},

	-- Sources configuration with better prioritization
	sources = {
		default = { "lsp", "snippets", "path", "buffer" },
		-- Enhanced sources for markdown files
		markdown = { "lsp", "path", "snippets", "buffer" },

		providers = {
			lsp = {
				name = "lsp",
				module = "blink.cmp.sources.lsp",
				-- Higher score offset means higher priority
				score_offset = 100,
			},
			snippets = {
				name = "snippets",
				module = "blink.cmp.sources.snippets",
				score_offset = 50,
			},
			path = {
				name = "path",
				module = "blink.cmp.sources.path",
				score_offset = 30,
				opts = {
					trailing_slash = true,
					label_trailing_slash = true,
					-- Enable both local and global path suggestions
					get_cwd = function(context)
						return vim.fn.getcwd()
					end,
					show_hidden_files_by_default = false,
				},
			},
			buffer = {
				name = "buffer",
				module = "blink.cmp.sources.buffer",
				-- Lower priority for buffer completions
				score_offset = -50,
				opts = {
					-- Only get completions from visible buffers
					get_bufnrs = function()
						local bufs = {}
						for _, win in ipairs(vim.api.nvim_list_wins()) do
							local buf = vim.api.nvim_win_get_buf(win)
							if vim.api.nvim_get_option_value("buftype", { buf = buf }) ~= "terminal" then
								bufs[buf] = true
							end
						end
						return vim.tbl_keys(bufs)
					end,
				},
			},
		},
	},

	-- Experimental signature help support
	signature = { enabled = true },

	completion = {
		accept = {
			-- Auto-add brackets for functions
			auto_brackets = {
				enabled = true,
			},
		},

		menu = {
			-- Draw additional information
			draw = {
				treesitter = { "lsp" },
			},
		},

		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},

		ghost_text = {
			enabled = false, -- Disable ghost text to reduce clutter
		},
	},

	-- Fuzzy matching configuration - less fuzzy, more predictable
	fuzzy = {
		-- REDUCED FUZZINESS: Stricter typo tolerance
		-- Only allow typos for longer words
		use_typo_resistance = false,  -- Disable typo resistance for more exact matching

		-- DISABLE FRECENCY for more predictable results
		-- This prevents recently used items from jumping to the top unexpectedly
		frecency = {
			enabled = false,
		},

		-- Proximity bonus - keep enabled but moderate
		-- This boosts items that are contextually near your cursor
		use_proximity = true,

		-- Maximum items to process
		max_items = 200,

		-- IMPORTANT: Sorting order for more predictable results
		-- Put exact matches and score first
		sorts = { "score", "sort_text", "label", "kind" },

		-- Prebuilt binary configuration
		prebuilt_binaries = {
			download = true,
			force_version = nil,
		},
	},
})