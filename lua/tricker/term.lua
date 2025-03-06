-- Terminal setup. inspired by Teeeeeeejjeeee
-- https://github.com/tjdevries/config.nvim/blob/c48edd3572c7b68b356ef7c54c41167b1f46e47c/plugin/terminal.lua

local set = vim.opt

-- Set local settings for terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", {}),
	callback = function()
		set.number = false
		set.relativenumber = false
		set.scrolloff = 0
	end,
})

-- Easily hit escape in terminal mode.
vim.keymap.set("t", "<esc>", "<c-\\><c-n>")

local buf = nil
local chan = nil
local open = false
local win = 0
-- Open a terminal at the bottom of the screen with a fixed height.
vim.keymap.set("n", "<leader>st", function()
	if win == 0 then
		buf = vim.api.nvim_create_buf(false, true)
		chan = vim.api.nvim_open_term(buf, {})
		win = vim.api.nvim_open_win(0, false, {
			split = "below",
			win = 0,
			height = 15,
		})
		open = true

		print("creating a new windows")

		return
	end

	if open then
		print("window was open, lets hide it")
		-- vim.api.nvim_win_set_config(win, {
		-- 	height = 0,
		-- })
		vim.api.nvim_win_hide(win)

		open = false
	else
		print("window was closed, lets open")
		vim.api.nvim_win_set_config(win, {
			height = 15,
		})
		open = true
	end

	-- if buf == nil then
	-- 	buf = vim.api.nvim_create_buf(false, true)
	-- 	chan = vim.api.nvim_open_term(buf, {})
	-- end
	--
	-- if open == false then
	-- 	print("New terminal buffer")
	-- 	print(buf)
	-- 	vim.cmd.vnew()
	-- 	vim.api.nvim_win_set_buf(0, buf)
	-- 	vim.api.nvim_win_set_height(0, 15)
	-- 	vim.cmd.wincmd("J")
	-- else
	-- end
end)
