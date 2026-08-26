-- neovim/nvim-lspconfig (+ mason + mason-lspconfig + mason-tool-installer)
-- Neovim 0.11 / mason-lspconfig v2 pattern

-- Disable LSP logging (htmx-lsp was spamming 39MB of errors)
vim.lsp.set_log_level("OFF")

-- LspAttach: capability-guarded keymaps
-- NOTE: document_highlight is NOT here — vim-illuminate already handles it
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if not client then
			return
		end

		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end
		local cap = client.server_capabilities

		if cap.definitionProvider then
			map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
		end

		if cap.referencesProvider then
			map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
		end

		if cap.implementationProvider then
			map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
		end

		if cap.typeDefinitionProvider then
			map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
		end

		if cap.documentSymbolProvider then
			map("<leader>ss", require("telescope.builtin").lsp_document_symbols, "[S]earch [S]ymbols")
		end

		if cap.workspaceSymbolProvider then
			map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
		end

		if cap.renameProvider then
			map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		end

		if cap.codeActionProvider then
			map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
		end

		if cap.hoverProvider then
			map("K", vim.lsp.buf.hover, "Hover Documentation")
		end

		if cap.declarationProvider then
			map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		end
	end,
})

-- Capabilities (blink.cmp completion support)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, blink_cmp = pcall(require, "blink.cmp")
if ok then
	capabilities = vim.tbl_deep_extend("force", capabilities, blink_cmp.get_lsp_capabilities())
end

-- Apply capabilities to ALL servers globally
vim.lsp.config("*", { capabilities = capabilities })

-- Server configurations (vim.lsp.config pattern for Neovim 0.11)
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
		},
	},
})

vim.lsp.config("basedpyright", {
	settings = {
		basedpyright = {
			analysis = {
				typeCheckingMode = "standard",
				autoImportCompletions = true,
			},
		},
	},
})

vim.lsp.config("ruff", {
	on_attach = function(client)
		-- Disable capabilities that overlap with basedpyright
		client.server_capabilities.hoverProvider = false
		client.server_capabilities.definitionProvider = false
	end,
})

vim.lsp.config("ts_ls", {
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
})

vim.lsp.config("svelte", {
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
})

vim.lsp.config("tailwindcss", {
	settings = {
		tailwindCSS = {
			experimental = {
				classRegex = {
					"class:([\\w-]+)",
					"tw`([^`]*)",
					"class(?:Name)?\\s*[=:]\\s*['\"`]([^'\"`]*)['\"`]",
				},
			},
		},
	},
})

vim.lsp.config("emmet_language_server", {
	filetypes = { "html", "htmldjango", "css", "scss", "less", "javascript", "javascriptreact", "typescriptreact", "svelte", "vue" },
})

vim.lsp.config("html", {
	filetypes = { "html", "htmldjango" },
})

vim.lsp.config("cssls", {
	settings = {
		css = {
			validate = true,
			lint = {
				unknownAtRules = "ignore",
			},
		},
	},
})

vim.lsp.config("jsonls", {
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})

-- Mason setup
require("mason").setup()

-- Non-LSP tools (formatters, debuggers)
require("mason-tool-installer").setup({
	ensure_installed = {
		"stylua",
		"biome",
		"prettier",
		"js-debug-adapter",
	},
})

-- LSP servers: install + auto-enable (mason-lspconfig v2)
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"basedpyright",
		"ruff",
		"ts_ls",
		"svelte",
		"tailwindcss",
		"html",
		"cssls",
		"jsonls",
		"emmet_language_server",
	},
	automatic_enable = true,
})
