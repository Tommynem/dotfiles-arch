-- nvim-treesitter/nvim-treesitter (new API for v1.0+)
local status_ok, _ = pcall(require, "nvim-treesitter")
if not status_ok then
  vim.notify("nvim-treesitter not installed or not loaded", vim.log.levels.WARN)
  return
end

-- Compatibility shim for plugins expecting old nvim-treesitter API
local ts_parsers = require("nvim-treesitter.parsers")

-- ft_to_lang: convert filetype to treesitter language
if not ts_parsers.ft_to_lang then
  ts_parsers.ft_to_lang = function(ft)
    local lang = vim.treesitter.language.get_lang(ft)
    return lang or ft
  end
end

-- get_parser_configs: return empty table (used for iteration)
if not ts_parsers.get_parser_configs then
  ts_parsers.get_parser_configs = function()
    return {}
  end
end

-- Shim for highlight module (used by telescope, etc.)
local ts_highlight_ok, ts_highlight = pcall(require, "nvim-treesitter.highlight")
if ts_highlight_ok and not ts_highlight.is_enabled then
  ts_highlight.is_enabled = function(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    return vim.treesitter.highlighter.active[bufnr] ~= nil
  end
end

-- Parsers to ensure are installed
local ensure_parsers = {
  "bash", "c", "html", "lua", "luadoc", "markdown", "vim", "vimdoc", "markdown_inline",
  "javascript", "typescript", "css", "json", "yaml", "python", "svelte", "tsx", "vue"
}

-- Install missing parsers on first run (TSInstall skips already-installed)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    for _, parser in ipairs(ensure_parsers) do
      -- Check if parser is installed by looking for the .so file
      local parser_path = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/parser/" .. parser .. ".so"
      if vim.fn.filereadable(parser_path) == 0 then
        vim.cmd("TSInstall " .. parser)
      end
    end
  end,
  once = true,
})

-- Enable treesitter-based highlighting for all buffers
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- Enable treesitter-based folding (optional)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false  -- Start with folds open

-- Incremental selection keymaps (wrapped in pcall for safety)
vim.keymap.set("n", "gnn", function()
  local ok, inc_sel = pcall(require, "nvim-treesitter.incremental_selection")
  if ok then inc_sel.init_selection() end
end, { desc = "Start incremental selection" })
vim.keymap.set("x", "grn", function()
  local ok, inc_sel = pcall(require, "nvim-treesitter.incremental_selection")
  if ok then inc_sel.node_incremental() end
end, { desc = "Increment to upper named node" })
vim.keymap.set("x", "grc", function()
  local ok, inc_sel = pcall(require, "nvim-treesitter.incremental_selection")
  if ok then inc_sel.scope_incremental() end
end, { desc = "Increment to upper scope" })
vim.keymap.set("x", "grm", function()
  local ok, inc_sel = pcall(require, "nvim-treesitter.incremental_selection")
  if ok then inc_sel.node_decremental() end
end, { desc = "Decrement to previous node" })
