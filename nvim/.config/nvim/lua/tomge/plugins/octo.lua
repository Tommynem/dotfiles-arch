require("octo").setup({
	-- Optional custom configuration
	ssh_aliases = {
		-- Specify additional SSH host aliases if needed
		-- ["github.com-work"] = "github.com",
	},
	default_remote = { "upstream", "origin" }, -- order to try remotes
	reaction_viewer_hint_icon = "", -- marker for user reactions
	user_icon = " ", -- user icon
	timeline_marker = "", -- timeline marker
	timeline_indent = 2, -- timeline indentation
	right_bubble_delimiter = "", -- bubble delimiter
	left_bubble_delimiter = "", -- bubble delimiter
	github_hostname = "", -- GitHub Enterprise host
	snippet_context_lines = 4, -- number of context lines around highlighted line
	file_panel = {
		size = 10, -- changed files panel size
		use_icons = true, -- use web-devicons in file panel
	},
	mappings = {
		-- You can customize keymappings here
		issue = {
			close_issue = "<space>ic", -- close issue
			reopen_issue = "<space>io", -- reopen issue
			list_issues = "<space>il", -- list open issues on same repo
			reload = "<C-r>", -- reload issue
			open_in_browser = "<C-b>", -- open issue in browser
			copy_url = "<C-y>", -- copy url to system clipboard
			add_assignee = "<space>aa", -- add assignee
			remove_assignee = "<space>ad", -- remove assignee
			create_label = "<space>lc", -- create label
			add_label = "<space>la", -- add label
			remove_label = "<space>ld", -- remove label
			goto_issue = "<space>gi", -- navigate to a local repo issue
			add_comment = "<space>ca", -- add comment
			delete_comment = "<space>cd", -- delete comment
			next_comment = "]c", -- go to next comment
			prev_comment = "[c", -- go to previous comment
			react_hooray = "<space>rp", -- add/remove 🎉 reaction
			react_heart = "<space>rh", -- add/remove ❤️ reaction
			react_eyes = "<space>re", -- add/remove 👀 reaction
			react_thumbs_up = "<space>r+", -- add/remove 👍 reaction
			react_thumbs_down = "<space>r-", -- add/remove 👎 reaction
			react_rocket = "<space>rr", -- add/remove 🚀 reaction
			react_laugh = "<space>rl", -- add/remove 😄 reaction
			react_confused = "<space>rc", -- add/remove 😕 reaction
		},
		pull_request = {
			-- Add PR-specific mappings if needed
		},
		review_thread = {
			-- Add review thread mappings if needed
		},
	},
})
