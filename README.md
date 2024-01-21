# tabtoggleterm.nvim

The tabtoggleterm.nvim plugin for Neovim provides an easy way to toggle a terminal window within your current tab. This plugin is useful for developers who need quick access to a terminal without leaving their Neovim environment.

## Features

Tab-specific Terminals: Opens a terminal in your current tab, ensuring a clean and organized workspace.
Toggle Functionality: Easily toggle the terminal window on and off within a tab.
Customizable Size: Set the default size of the terminal window according to your preference.
Terminal Session Management: Handles the creation and destruction of terminal buffers and windows efficiently.

## Requirements

Neovim (0.95 or newer)

## Installation

You can install the tabtoggleterm.nvim plugin using your favorite package manager. For example, using packer:

```vim
use "watanany/tabtoggleterm.nvim"
```

## Configuration

After installation, you can configure the plugin by setting the terminal window size in your init.vim or init.lua file:

```lua
require("tabtoggleterm").setup({
  size = 20, -- Default terminal size, you can change this value
})

vim.keymap.set("n", "<Space>ot", require("tabtoggleterm").tab_toggle_term, { noremap = true, silent = true })
```

## Usage

To toggle the terminal in your current tab, use the following Neovim command:

```vim
:TabToggleTerm!
```

This command opens a terminal in the current tab if it's not open, or closes it if it's already open.

## License

This plugin is distributed under the MIT License.

## Related Projects
- [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)
