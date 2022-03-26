# jest.nvim
Forked from [kubejm/jest.nvim](https://github.com/kubejm/jest.nvim)
Added nvim-dap debugging and rearranged windows a bit.
Ability to invoke jest within nvim.

## Requirements

* Neovim
* Jest (within node_modules of working project)
* nvim-dap

## Installation

```vim
Plug 'arajski/jest.nvim'
```

## Usage

| Command       | Description                        |
| ---           | ---                                |
| `:Jest`       | Run Jest on entire project         |
| `:JestFile`   | Run Jest on file in current buffer |
| `:JestSingle` | Run Jest on test name under cursor |
| `:JestDebug`  | Debug Jest on a single test case   |
