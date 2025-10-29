# Neovim Configuration

A modern Neovim configuration with comprehensive support for Python development, web development, debugging, testing, and note-taking with Obsidian.

## Features

- **Language Support**: Full LSP configuration with auto-completion via blink.cmp
- **Python Development**: Integrated debugging with DAP, testing with pytest, and coverage analysis
- **Web Development**: Support for JavaScript, TypeScript, Svelte, and SvelteKit
- **Testing**: Comprehensive testing integration with neotest and custom test runners
- **Git Integration**: Gitsigns, Lazygit, and GitHub integration via Octo
- **File Management**: Oil.nvim for file exploration and Telescope for fuzzy finding
- **Note Taking**: Obsidian.nvim integration for seamless note management
- **UI Enhancements**: Catppuccin theme, lualine statusline, and WhichKey for keybinding discovery

## Prerequisites

- Neovim >= 0.9.0
- Git
- Node.js and npm (for LSP servers and web development)
- Python 3.x with pip (for Python development)
- ripgrep (for fast searching)
- fd (for file finding)
- A Nerd Font (for icons)

## Installation

1. **Backup your existing Neovim configuration** (if any):
```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

2. **Clone this repository**:
```bash
git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim
```

3. **Install plugin manager** (Lazy.nvim):
The configuration will automatically install Lazy.nvim on first launch.

4. **Launch Neovim**:
```bash
nvim
```
Lazy.nvim will automatically install all plugins on first launch.

5. **Install LSP servers**:
After plugins are installed, run:
```vim
:Mason
```
Install the language servers you need (e.g., pyright, typescript-language-server, etc.)

## Configuration

### Obsidian Integration

To use the Obsidian integration, set the `OBSIDIAN_VAULT_PATH` environment variable with the full absolute path:

```bash
export OBSIDIAN_VAULT_PATH="/Users/yourusername/path/to/your/obsidian/vault"
```

If not set, it defaults to `~/Documents/ObsidianVault` (automatically expanded).

### Python Development

The configuration includes comprehensive Python support with:
- **Debugging**: DAP integration with debugpy
- **Testing**: pytest integration via neotest
- **Coverage**: Coverage.py integration
- **Formatting**: Black and isort via conform.nvim

### Key Mappings

Leader key is set to `<Space>`.

#### General
- `<Space>q` - Save and quit all
- `<Space><Space>` - Toggle previous buffer
- `<Space>x` - Close current buffer
- `-` - Open file explorer (Oil)

#### Search (Telescope)
- `<Space>sf` - Search files
- `<Space>sg` - Live grep
- `<Space>sh` - Search help
- `<Space>sr` - Resume last search
- `/` - Fuzzy search in current buffer

#### Testing
- `<Space>tt` - Run all tests
- `<Space>tc` - Run coverage
- `<Space>tf` - Test current file
- `<Space>tm` - Test current method

#### Debugging
- `<Space>db` - Toggle breakpoint
- `<Space>dc` - Continue
- `<Space>di` - Step into
- `<Space>do` - Step out
- `<Space>du` - Toggle DAP UI

#### Git
- `<Space>lg` - Open Lazygit
- `<Space>gb` - Git blame current line
- `<Space>gB` - Open file in browser

#### Obsidian
- `<Space>on` - Create new note
- `<Space>oo` - Open current note in Obsidian
- `<Space>of` - Search vault files
- `<Space>og` - Grep vault

## Plugin Structure

The configuration is modular with plugins organized in `lua/tomge/plugins/`:
- Each plugin has its own configuration file
- Core settings are in `lua/tomge/init.lua`
- Keymappings are centralized in `lua/tomge/remap.lua`

## Customization

1. **Add new plugins**: Create a new file in `lua/tomge/plugins/`
2. **Modify keybindings**: Edit `lua/tomge/remap.lua`
3. **Change settings**: Edit `lua/tomge/set.lua`

## Troubleshooting

1. **Check health**:
```vim
:checkhealth
```

2. **Update plugins**:
```vim
:Lazy update
```

3. **Clear plugin cache**:
```vim
:Lazy clean
```

## License

This configuration is provided as-is for public use. Feel free to fork and modify for your needs.

## Credits

This configuration uses various community plugins and configurations. Special thanks to all the plugin authors and the Neovim community.