-- --  Inspired by lspcontainer.nvim
-- -- https://github.com/lspcontainers/lspcontainers.nvim/blob/main/lua/lspcontainers/init.lua
-- local docker_cmd = function(name, image, workdir, network, docker_volume)
-- 	if workdir == nil then
-- 		workdir = vim.fn.getcwd()
-- 	end
--
-- 	local mnt_volume
-- 	if docker_volume ~= nil then
-- 		mnt_volume = "--volume=" .. docker_volume .. ":" .. workdir .. ":z"
-- 	else
-- 		mnt_volume = "--volume=" .. workdir .. ":" .. workdir .. ":z"
-- 	end
--
-- 	if network == nil then
-- 		network = "none"
-- 	end
--
-- 	return {
-- 		"docker",
-- 		"run",
-- 		"--rm",
-- 		"-it",
-- 		"--platform=linux/amd64",
-- 		-- "--name=nvim-lsp-" .. name,
-- 		"--network=" .. network,
-- 		"--workdir=" .. workdir,
-- 		mnt_volume,
-- 		image,
-- 	}
-- end

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		log_level = vim.log.levels.TRACE,
		formatters_by_ft = {
			lua = { "stylua" },
			-- Use a sub-list to run only the first available formatter
			javascript = { "prettier" },
			typescript = { 'prettierd', 'prettier', stop_after_first = true },
			typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
			json = { "prettier" },
			jsonc = { "prettier" },
			yaml = { "prettier" },
			html = { "prettier" },
			toml = { "prettier" },
			vue = { "prettier" },
			jsx = { "prettier" },
			volar = { "prettier" },
			markdown = {
				"mdformat",
				"markdown-toc",
				"markdownlint",
			},
			css = { "stylelint", "prettier" },
		},
	},
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

		-- Create a command `:Format` local to the LSP buffer
		-- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#format-command
		vim.api.nvim_create_user_command("Format", function(args)
			local range = nil
			if args.count ~= -1 then
				local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
				range = {
					start = { args.line1, 0 },
					["end"] = { args.line2, end_line:len() },
				}
			end
			require("conform").format({ async = true, lsp_format = "fallback", range = range })
		end, { range = true })
	end,
}
