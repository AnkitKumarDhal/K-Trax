-- ~/.config/nvim/lua/core/autocmds.lua
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
	group = augroup("YankHighlight", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
	end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
	group = augroup("TrimWhitespace", { clear = true }),
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

-- Resize splits when window is resized
autocmd("VimResized", {
	group = augroup("ResizeSplits", { clear = true }),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- Go to last location when reopening a file
autocmd("BufReadPost", {
	group = augroup("LastLocation", { clear = true }),
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Close certain filetypes with just <q>
autocmd("FileType", {
	group = augroup("CloseWithQ", { clear = true }),
	pattern = { "help", "man", "qf", "lspinfo", "checkhealth", "notify" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Auto-format on save is handled by conform.nvim (in tools.lua)
-- but we disable it for certain filetypes:
autocmd("FileType", {
	group = augroup("NoAutoFormat", { clear = true }),
	pattern = { "markdown", "text" },
	callback = function()
		vim.b.autoformat = false
	end,
})
