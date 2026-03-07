# alloy.nvim

Neovim plugin for [Alloy 6](https://alloytools.org/) syntax highlighting using tree-sitter.

## Requirements

- Neovim >= 0.9.0
- A C compiler (cc/gcc/clang)

## Installation

1. Install the plugin however you like (lazy.nvim, vim-plug, manual clone, etc.)
2. Build the parser:

```sh
cd /path/to/alloy.nvim
./build.sh /path/to/tree-sitter-alloy
```

That's it. Open any `.als` file and you get syntax highlighting.

### Example: lazy.nvim

```lua
{
  "vincentlu/alloy.nvim",
  build = "./build.sh /path/to/tree-sitter-alloy",
}
```

### Example: manual

```sh
git clone https://github.com/vincentlu/alloy.nvim \
  ~/.local/share/nvim/site/pack/plugins/start/alloy.nvim
cd ~/.local/share/nvim/site/pack/plugins/start/alloy.nvim
./build.sh /path/to/tree-sitter-alloy
```

## Features

- Filetype detection for `.als` files
- Tree-sitter based syntax highlighting
- Comment string set to `//` for easy commenting
