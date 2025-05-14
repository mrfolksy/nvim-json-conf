# nvim-json-conf

A Neovim plugin that loads a per-project `.nvimconf.json` into a Lua table that can be used in your own Neovim configuration, for example to load project specific settings for LSPs.

## Installation (LazyVim)

```lua
-- ~/.config/nvim/lua/plugins/nvim-json-conf.lua

return {
  "mrfolksy/nvim-json-conf",
}
```

## Basic Usage

Create a `.nvimconf.json` at your project root, can be any JSON structure. The example below outlines and example of setting a project specific value (configFile) for the tailwindcss language server.

```
{
  "lsp": {
    "tailwindcss": {
      "settings": {
        "tailwindCSS": {
          "experimental": {
            "configFile": "path/to/styles.css"
          }
        }
      }
    }
  }
}
```

This can then be accessed as a Lua table.

```lua
local project_cfg = require("nvim-json-conf").get()
```

## LSP Configuration Example

Either ensure the plugin is installed (see above section) or add `nvim-json-conf` as a dependency in locations where you want to use your project config in your Neovim configuration. You can then access your config as a Lua table.

```lua
return {
  "neovim/nvim-lspconfig",
  dependencies = { "mrfolksy/nvim-json-conf" },
  opts = {
    servers = {
      tailwindcss = {},
    },
    setup = {
      tailwindcss = function(_, opts)
        local project_cfg = require("nvim-json-conf").get()

        -- get per-project TailwindCSS settings
        local tw = project_cfg.lsp
          and project_cfg.lsp.tailwindcss
          and project_cfg.lsp.tailwindcss.settings
          or {}

        -- Merge into existing opts.settings
        opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, tw)

        require("lspconfig").tailwindcss.setup(opts)
        return true
      end,
    },
  },
}



```
