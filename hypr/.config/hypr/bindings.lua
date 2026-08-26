-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

hl.unbind("SUPER + T")
hl.unbind("SUPER + SHIFT + F")
hl.unbind("SUPER + SHIFT + N")
hl.unbind("SUPER + O")
hl.unbind("SUPER + P")
hl.unbind("SUPER + SHIFT + P")
hl.unbind("SUPER + CTRL + P")
hl.unbind("SUPER + SHIFT + S")
hl.unbind("SUPER + SHIFT + ALT + B")
hl.unbind("SUPER + SHIFT + ALT + M")
hl.unbind("SUPER + SHIFT + G")
hl.unbind("SUPER + ALT + LEFT")
hl.unbind("SUPER + ALT + RIGHT")

o.bind("SUPER + E", "File manager", 'uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" -e yazi')
o.bind("SUPER + ALT + B", "Browser", "omarchy-launch-browser")
o.bind("SUPER + SHIFT + ALT + B", "Secondary browser", "setsid uwsm-app -- chromium")

o.bind("SUPER + N", "neovide", 'omarchy-launch-or-focus "neovide" "uwsm-app -- neovide"')
o.bind("SUPER + SHIFT + N", "nvim", "omarchy-launch-editor")
o.bind("SUPER + ALT + T", "Activity", "uwsm-app -- xdg-terminal-exec -e btop")
o.bind("SUPER + ALT + L", "Lazygit", 'uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" -e lazygit')
o.bind("SUPER + O", "Obsidian", 'omarchy-launch-or-focus "^obsidian$" "uwsm-app -- obsidian"')

o.bind("SUPER + ALT + A", "Claude", 'omarchy-launch-webapp "https://claude.ai"')
o.bind("SUPER + ALT + M", "Email", 'omarchy-launch-or-focus "thunderbird" "uwsm-app -- thunderbird"')
o.bind("SUPER + Y", "YouTube", 'omarchy-launch-webapp "https://youtube.com/"')
o.bind("SUPER + SHIFT + ALT + M", "WhatsApp", 'omarchy-launch-or-focus-webapp "WhatsApp" "https://web.whatsapp.com/"')
o.bind("SUPER + SHIFT + G", "GitHub", 'omarchy-launch-or-focus-webapp "GitHub" "https://github.com"')

o.bind("SUPER + P", "Screenshot with editing", "omarchy-capture-screenshot")
o.bind("SUPER + SHIFT + P", "Screenshot to clipboard", "omarchy-capture-screenshot smart copy")
o.bind("SUPER + ALT + P", "Screen recording", "omarchy-menu screenrecord")
o.bind("SUPER + CTRL + P", "Color picker", "pkill hyprpicker || hyprpicker -a")
o.bind("SUPER + SHIFT + S", "Screenshot snip", "omarchy-capture-screenshot")

o.bind("SUPER + Q", "Close window", hl.dsp.window.close())
o.bind("SUPER + SHIFT + Q", "Close all windows", "omarchy-hyprland-window-close-all")
o.bind("SUPER + SHIFT + F", "Toggle floating window", hl.dsp.window.float({ action = "toggle" }))

o.bind("SUPER + ALT + LEFT", "Move workspace to left monitor", hl.dsp.workspace.move({ monitor = "l" }))
o.bind("SUPER + ALT + RIGHT", "Move workspace to right monitor", hl.dsp.workspace.move({ monitor = "r" }))
