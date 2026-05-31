-- ~/.config/nvim/init.lua
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core settings first
require("core.options")
require("core.autocmds")
require("lazy_bootstrap")

-- Load keymaps after plugins (so which-key can register descriptions)
require("core.mappings")
