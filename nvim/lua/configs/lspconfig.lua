require("nvchad.configs.lspconfig").defaults()
local nvlsp = require "nvchad.configs.lspconfig"

local servers = { "html", "cssls", "clangd", "tailwindcss", "ts_ls", "pyright", "gopls", "lua_ls", "qmljs" }

for _, lsp in ipairs(servers) do
    -- 1. Configure the server with NvChad's UI and mapping defaults
    vim.lsp.config(lsp, {
        on_attach = nvlsp.on_attach,
        on_init = nvlsp.on_init,
        capabilities = nvlsp.capabilities,
    })

    -- 2. Explicitly enable the configured server
    vim.lsp.enable(lsp)
end
