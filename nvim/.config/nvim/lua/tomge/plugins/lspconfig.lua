-- neovim/nvim-lspconfig (+ mason + mason-lspconfig + mason-tool-installer)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		-- NOTE: Remember that Lua is a real programming language, and as such it is possible
		-- to define small helper and utility functions so you don't have to repeat yourself.
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end
		map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

		map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

		map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

		map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

		map("<leader>ss", require("telescope.builtin").lsp_document_symbols, "[S]earch [S]ymbols")

		map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

		map("K", vim.lsp.buf.hover, "Hover Documentation")

		-- WARN: This is not Goto Definition, this is Goto Declaration.
		--  For example, in C this would take you to the header.
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client.server_capabilities.documentHighlightProvider then
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				callback = vim.lsp.buf.clear_references,
			})
		end
	end,
})
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- Updated for blink.cmp instead of nvim-cmp
local ok, blink_cmp = pcall(require, "blink.cmp")
if ok then
	capabilities = vim.tbl_deep_extend("force", capabilities, blink_cmp.get_lsp_capabilities())
else
	-- Fallback to default capabilities if blink.cmp isn't available
	capabilities = vim.lsp.protocol.make_client_capabilities()
end
local servers = {
	lua_ls = {
		settings = {
			Lua = {
				completion = {
					callSnippet = "Replace",
				},
			},
		},
	},
	pylsp = {
		settings = {
			pylsp = {
				plugins = {
					-- Formatter settings
					black = { enabled = true },
					isort = { enabled = true },

					-- Linter settings
					pylint = {
						enabled = true,
						args = { "--max-line-length=120", "--disable=C0111" },
					},
					flake8 = {
						enabled = true,
						maxLineLength = 120,
						ignore = { "E203", "W503" }, -- Black compatibility
					},
					mypy = {
						enabled = true,
						live_mode = true,
						strict = false,
					},

					-- Disable some default plugins
					pycodestyle = { enabled = false }, -- Using flake8 instead
					mccabe = { enabled = false },
					pyflakes = { enabled = false }, -- Using flake8 instead
					yapf = { enabled = false }, -- Using black instead
				},
			},
		},
	},
	ruff = {
		-- Use the new ruff LSP server instead of the deprecated ruff_lsp
		-- Ruff LSP handles linting, pylsp handles language features
	},
	-- Web Development Language Servers (2025)
	ts_ls = {
		settings = {
			typescript = {
				preferences = {
					includeCompletionsForModuleExports = true,
				},
			},
			javascript = {
				preferences = {
					includeCompletionsForModuleExports = true,
				},
			},
		},
	},
	svelte = {
		settings = {
			svelte = {
				plugin = {
					typescript = {
						enabled = true,
						diagnostics = { enable = true },
						hover = { enable = true },
						documentSymbols = { enable = true },
						completions = {
							enable = true,
							emmet = true,
						},
						codeActions = { enable = true },
						selectionRange = { enable = true },
						rename = { enable = true },
					},
					css = { enable = true },
					html = { enable = true },
				},
			},
		},
		on_attach = function(client, bufnr)
			-- Auto-update imports when TypeScript files change
			vim.api.nvim_create_autocmd({"BufWritePost"}, {
				pattern = {"*.js", "*.ts"},
				callback = function()
					vim.lsp.buf.code_action({
						filter = function(action)
							return action.kind and string.match(action.kind, "source")
						end,
						apply = true
					})
				end,
			})
		end,
	},
	tailwindcss = {
		settings = {
			tailwindCSS = {
				experimental = {
					classRegex = {
						-- Svelte class directives
						"class:([\\w-]+)",
						-- Template literals
						"tw`([^`]*)",
						-- clsx, classnames, etc.
						"class(?:Name)?\\s*[=:]\\s*['\"`]([^'\"`]*)['\"`]",
					},
				},
			},
		},
	},
	html = {},
	cssls = {
		settings = {
			css = {
				validate = true,
				lint = {
					unknownAtRules = "ignore", -- Ignore unknown Tailwind directives
				},
			},
		},
	},
	jsonls = {
		settings = {
			json = {
				schemas = require('schemastore').json.schemas(),
				validate = { enable = true },
			},
		},
	},
}

require("mason").setup()

-- LSP servers only
local lsp_servers = vim.tbl_keys(servers or {})

-- Formatting tools and debuggers (NOT LSP servers)
local mason_tools = {
	"stylua", -- Used to format Lua code
	-- Modern web development tools (2025)
	"biome", -- Modern ESLint + Prettier replacement (Rust-based, 15x faster)
	"prettier", -- Fallback formatter for files Biome doesn't support
	"js-debug-adapter", -- Modern JavaScript debugging
}

-- Map server names to their mason package names
local mason_package_names = {
	pylsp = "python-lsp-server",
	ruff = "ruff",
	lua_ls = "lua-language-server",
	-- Web development servers
	ts_ls = "typescript-language-server",
	svelte = "svelte-language-server",
	tailwindcss = "tailwindcss-language-server",
	html = "html-lsp",
	cssls = "css-lsp",
	jsonls = "json-lsp",
}

-- Install tools (formatters, debuggers, etc.) via mason-tool-installer
require("mason-tool-installer").setup({ ensure_installed = mason_tools })

require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls", "pylsp", "ruff",
		-- Web development servers
		"ts_ls", "svelte", "tailwindcss", "html", "cssls", "jsonls"
	},
	handlers = {
		function(server_name)
			local server = servers[server_name] or {}
			-- Specific setup for pyright (if you had it)
			if server_name == "pyright" then
				server.settings = {
					python = {
						pythonPath = "/Library/Frameworks/Python.framework/Versions/3.12/bin/python3", -- Set this to your specific Python interpreter
					},
				}
			end
			server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
			require("lspconfig")[server_name].setup(server)
		end,
	},
})
