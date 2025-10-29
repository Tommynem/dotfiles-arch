-- stevearc/conform.nvim
require("conform").setup({
  notify_on_error = false,
  format_on_save = function(bufnr)
    local disable_filetypes = { c = true, cpp = true }
    return {
      timeout_ms = 500,
      lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
    }
  end,
  formatters_by_ft = {
    lua = { "stylua" },
    -- Modern Web Development (2025) - Biome first, Prettier fallback
    javascript = { "biome", "prettier" },
    typescript = { "biome", "prettier" },
    javascriptreact = { "biome", "prettier" },
    typescriptreact = { "biome", "prettier" },
    json = { "biome", "prettier" },
    jsonc = { "biome", "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    html = { "prettier" },
    svelte = { "prettier" }, -- Biome doesn't support Svelte yet
    vue = { "prettier" },
    astro = { "prettier" },
    markdown = { "prettier" },
    yaml = { "prettier" },
    toml = { "prettier" },
  },
  -- Custom formatter configurations
  formatters = {
    biome = {
      command = "biome",
      args = { "format", "--stdin-file-path", "$FILENAME" },
      stdin = true,
      cwd = require("conform.util").root_file({ "biome.json", ".biomejs.json" }),
    },
  },
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "[F]ormat buffer" })
