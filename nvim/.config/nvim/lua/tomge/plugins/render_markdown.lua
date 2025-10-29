-- render-markdown.nvim configuration for Obsidian-like markdown rendering
return {
	setup = function()
		require("render-markdown").setup({
			-- Start enabled by default (markdown is rendered)
			enabled = true,
			-- Maximum file size to render (in MB)
			max_file_size = 10.0,
			-- Milliseconds delay before rendering
			debounce = 100,
			-- Render in all modes by default
			render_modes = { "n", "c", "i", "v", "V", "^V", "t" },
			-- Don't skip rendering based on conceallevel
			anti_conceal = { enabled = true },
			-- Set win_options for better rendering
			win_options = {
				conceallevel = { default = 2, rendered = 2 },
				concealcursor = { default = "", rendered = "" }, -- Always show raw when cursor is on line
			},
			-- Latex configuration (optional)
			latex = { enabled = false },
			-- Heading configuration with backgrounds and icons
			heading = {
				enabled = true,
				sign = true,
				icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
				backgrounds = {
					"RenderMarkdownH1Bg",
					"RenderMarkdownH2Bg",
					"RenderMarkdownH3Bg",
					"RenderMarkdownH4Bg",
					"RenderMarkdownH5Bg",
					"RenderMarkdownH6Bg",
				},
				foregrounds = {
					"RenderMarkdownH1",
					"RenderMarkdownH2",
					"RenderMarkdownH3",
					"RenderMarkdownH4",
					"RenderMarkdownH5",
					"RenderMarkdownH6",
				},
			},
			-- Paragraph configuration
			paragraph = {
				enabled = true,
				left_margin = 0,
				min_width = 0,
			},
			-- Code block configuration with language icons
			code = {
				enabled = true,
				sign = true,
				style = "full",
				position = "left",
				language_pad = 0,
				language_name = true,
				disable_background = { "diff" },
				width = "full",
				left_margin = 0,
				left_pad = 0,
				right_pad = 0,
				min_width = 0,
				border = "thin",
				above = "▄",
				below = "▀",
				highlight = "RenderMarkdownCode",
				highlight_inline = "RenderMarkdownCodeInline",
			},
			-- Dashed line for thematic breaks
			dash = {
				enabled = true,
				icon = "─",
				width = "full",
				highlight = "RenderMarkdownDash",
			},
			-- Bullet points configuration
			bullet = {
				enabled = true,
				icons = { "●", "○", "◆", "◇" },
				ordered_icons = function(ctx)
					local value = string.format("%d.", ctx.index)
					return string.format("%" .. ctx.level .. "s", value)
				end,
				left_pad = 0,
				right_pad = 0,
				highlight = "RenderMarkdownBullet",
			},
			-- Checkbox configuration
			checkbox = {
				enabled = true,
				position = "inline",
				unchecked = { icon = "󰄱 ", highlight = "RenderMarkdownUnchecked" },
				checked = { icon = "󰱒 ", highlight = "RenderMarkdownChecked" },
				custom = {
					todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
					important = { raw = "[!]", rendered = "󰅾 ", highlight = "RenderMarkdownImportant" },
					note = { raw = "[~]", rendered = "󰋽 ", highlight = "RenderMarkdownNote" },
					cancelled = { raw = "[/]", rendered = "󰰱 ", highlight = "RenderMarkdownCancelled" },
				},
			},
			-- Quote configuration
			quote = {
				enabled = true,
				icon = "▌",
				repeat_linebreak = false,
				highlight = "RenderMarkdownQuote",
			},
			-- Pipe table configuration
			pipe_table = {
				enabled = true,
				preset = "heavy",
				style = "full",
				cell = "padded",
				alignment_indicator = "━",
				border = {
					"┏",
					"┳",
					"┓",
					"┣",
					"╋",
					"┫",
					"┗",
					"┻",
					"┛",
					"┃",
					"━",
				},
				head = "RenderMarkdownTableHead",
				row = "RenderMarkdownTableRow",
				filler = "RenderMarkdownTableFill",
			},
			-- Callout configuration (for notes, warnings, etc.)
			callout = {
				note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
				tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
				important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
				warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
				caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
				abstract = { raw = "[!ABSTRACT]", rendered = "󰨸 Abstract", highlight = "RenderMarkdownInfo" },
				summary = { raw = "[!SUMMARY]", rendered = "󰨸 Summary", highlight = "RenderMarkdownInfo" },
				tldr = { raw = "[!TLDR]", rendered = "󰨸 TL;DR", highlight = "RenderMarkdownInfo" },
				info = { raw = "[!INFO]", rendered = "󰋽 Info", highlight = "RenderMarkdownInfo" },
				todo = { raw = "[!TODO]", rendered = " Todo", highlight = "RenderMarkdownInfo" },
				hint = { raw = "[!HINT]", rendered = "󰌶 Hint", highlight = "RenderMarkdownSuccess" },
				success = { raw = "[!SUCCESS]", rendered = "󰄬 Success", highlight = "RenderMarkdownSuccess" },
				check = { raw = "[!CHECK]", rendered = "󰄬 Check", highlight = "RenderMarkdownSuccess" },
				done = { raw = "[!DONE]", rendered = "󰄬 Done", highlight = "RenderMarkdownSuccess" },
				question = { raw = "[!QUESTION]", rendered = "󰘥 Question", highlight = "RenderMarkdownWarn" },
				help = { raw = "[!HELP]", rendered = "󰘥 Help", highlight = "RenderMarkdownWarn" },
				faq = { raw = "[!FAQ]", rendered = "󰘥 FAQ", highlight = "RenderMarkdownWarn" },
				attention = { raw = "[!ATTENTION]", rendered = "󰀪 Attention", highlight = "RenderMarkdownWarn" },
				failure = { raw = "[!FAILURE]", rendered = "󰅖 Failure", highlight = "RenderMarkdownError" },
				fail = { raw = "[!FAIL]", rendered = "󰅖 Fail", highlight = "RenderMarkdownError" },
				missing = { raw = "[!MISSING]", rendered = "󰅖 Missing", highlight = "RenderMarkdownError" },
				danger = { raw = "[!DANGER]", rendered = "󱐌 Danger", highlight = "RenderMarkdownError" },
				error = { raw = "[!ERROR]", rendered = "󱐌 Error", highlight = "RenderMarkdownError" },
				bug = { raw = "[!BUG]", rendered = "󰨰 Bug", highlight = "RenderMarkdownError" },
				example = { raw = "[!EXAMPLE]", rendered = "󰉹 Example", highlight = "RenderMarkdownHint" },
				quote = { raw = "[!QUOTE]", rendered = "󱆨 Quote", highlight = "RenderMarkdownQuote" },
				cite = { raw = "[!CITE]", rendered = "󱆨 Cite", highlight = "RenderMarkdownQuote" },
			},
			-- Link configuration
			link = {
				enabled = true,
				image = "󰥶 ",
				email = "󰀓 ",
				hyperlink = "󰌹 ",
				highlight = "RenderMarkdownLink",
				wiki = { icon = "󱗖 ", highlight = "RenderMarkdownWikiLink" },
				custom = {
					web = { pattern = "^http[s]?://", icon = "󰖟 ", highlight = "RenderMarkdownWebLink" },
				},
			},
			-- Sign column configuration
			sign = {
				enabled = true,
				exclude = { buftypes = { "nofile" } },
			},
			-- Inline highlight configuration
			inline_highlight = {
				enabled = true,
				query = {
					block = {
						-- Code blocks
						raw = "vim.api.nvim_get_runtime_file('queries/markdown/markdown.scm', false)[1]",
						lang = "markdown",
						query = [[
              (fenced_code_block) @codeblock
            ]],
					},
				},
				-- Bold
				strong = {
					pattern = "%*%*().-()%*%*",
					group = "RenderMarkdownBold",
					conceal = true,
					icon = "",
				},
				-- Italic
				italic = {
					pattern = "%*().-()%*",
					group = "RenderMarkdownItalic",
					conceal = true,
					icon = "",
				},
				-- Strikethrough
				strikethrough = {
					pattern = "~~().-()~~",
					group = "RenderMarkdownStrikethrough",
					conceal = true,
					icon = "",
				},
				-- Code
				code = {
					pattern = "`().-`",
					group = "RenderMarkdownCodeInline",
					conceal = false,
					icon = "",
				},
				-- Subscript
				subscript = {
					pattern = "%~().-()%~",
					group = "RenderMarkdownSubscript",
					conceal = true,
					icon = "",
				},
				-- Superscript
				superscript = {
					pattern = "%^().-()%^",
					group = "RenderMarkdownSuperscript",
					conceal = true,
					icon = "",
				},
			},
		})
	end,
}