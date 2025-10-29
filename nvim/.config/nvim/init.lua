require("tomge")
vim.g.have_nerd_font = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
vim.opt.conceallevel = 2
vim.opt.concealcursor = "nc"
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.g.python3_host_prog = "/usr/bin/python3"
vim.g.netrw_browsex_viewer = "xdg-open"

-- Disable unused providers to avoid warnings
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.opt.path:append(".,/usr/include,")

-- disable base file explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

if vim.g.neovide then
	-- Font Configuration
	vim.o.guifont = "CaskaydiaMono Nerd Font:h11"

	-- Window Styling & Transparency
	vim.g.neovide_opacity = 0.85
	vim.g.transparency = 0.8
	vim.g.neovide_normal_opacity = 0.9 -- Background opacity (slightly less transparent)

	-- Window Padding for cleaner look
	vim.g.neovide_padding_top = 15
	vim.g.neovide_padding_bottom = 15
	vim.g.neovide_padding_right = 20
	vim.g.neovide_padding_left = 20

	-- Rounded corners for floating windows (0.0 to 1.0)
	vim.g.neovide_floating_corner_radius = 0.6

	-- Theme integration - disable auto to respect Neovim colorscheme
	-- Note: Neovide will follow the colorscheme set by theme-switcher.lua
	-- which automatically syncs with Omarchy's theme system
	vim.g.neovide_theme = nil -- Let Neovim colorscheme control theme

	-- Smooth animations for modern feel
	vim.g.neovide_cursor_animation_length = 0.1
	vim.g.neovide_cursor_trail_size = 0.3
	vim.g.neovide_scroll_animation_length = 0.2

	vim.g.neovide_text_gamma = 0.0
	vim.g.neovide_text_contrast = 0.5
end
