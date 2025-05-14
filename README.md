# nvim-json-conf

A Neovim plugin that loads a per-project `.nvimconf.json` into a Lua table that can be used in your own Neovim configuration, for example to load project specific settings for LSPs.

## Installation

```lua
return {
  "mrfolksy/nvim-json-conf",
  config = function()
    require("nvim-json-conf").setup()
  end,
}
```

## Usage

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

Then in your Neovim configuration you can access this config as a Lua table when configuring the tailwindcss language server.

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

