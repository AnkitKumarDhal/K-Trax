require "nvchad.options"
-- add yours here!
local opt = vim.opt
opt.shiftwidth = 4 -- number of spaces for each step of (auto)indent
opt.tabstop = 4 -- number of spaces that a <Tab> counts for while editing
opt.expandtab = true -- use spaces instead of tabs
opt.relativenumber = true -- show relative line numbers
opt.mouse = "a"
opt.scrolloff = 4
local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!
