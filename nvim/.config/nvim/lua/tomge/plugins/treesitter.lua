require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash", "c", "html", "lua", "luadoc", "markdown", "markdown_inline",
    "vim", "vimdoc", "javascript", "typescript", "tsx", "css", "json",
    "yaml", "python", "svelte", "vue",
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
})

vim.treesitter.language.register("html", "htmldjango")

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false
