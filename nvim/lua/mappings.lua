require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local del = vim.keymap.del

map("n", ";", ":", { desc = "CMD enter command mode" })

-- delete the default mapping for split terminal windows
del("n", "<leader>h")
del("n", "<leader>v")

-- Map them to open actual code/file splits instead
map("n", "<leader>h", "<cmd>split<cr>", { desc = "Window: Horizontal Split" })
map("n", "<leader>v", "<cmd>vsplit<cr>", { desc = "Window: Vertical Split" })

-- Move between file splits
map("n", "<A-h>", "<C-w>h", { desc = "Window: Focus Left" })
map("n", "<A-l>", "<C-w>l", { desc = "Window: Focus Right" })
map("n", "<A-j>", "<C-w>j", { desc = "Window: Focus Down" })
map("n", "<A-k>", "<C-w>k", { desc = "Window: Focus Up" })

-- Resize splits quickly with Arrow Keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Window: Increase Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Window: Decrease Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Window: Decrease Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Window: Increase Width" })

-- Debugging keymaps
map("n", "<leader>db", "<cmd> DapToggleBreakpoint <cr>", { desc = "Debug: Toggle Breakpoint" })
map("n", "<leader>dr", "<cmd> DapContinue <cr>", { desc = "Debug: Start/Continue" })
map("n", "<leader>di", "<cmd> DapStepInto <cr>", { desc = "Debug: Step Into" })
map("n", "<leader>do", "<cmd> DapStepOver <cr>", { desc = "Debug: Step Over" })
map("n", "<leader>dt", "<cmd> DapTerminate <cr>", { desc = "Debug: Terminate" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- In lua/mappings.lua
map("i", "<C-;>", "<Esc>mzA;<Esc>`za", { desc = "Auto-add semicolon at end of line" })
map("n", "<leader>;", "mzA;<Esc>`z", { desc = "Auto-add semicolon at end of line" })

-- AI Assistant mappings
map({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI: Chat" })
map({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionActions<cr>", { desc = "AI: Actions" })
map("v", "<leader>ci", "<cmd>CodeCompanion<cr>", { desc = "AI: Inline Edit" })
