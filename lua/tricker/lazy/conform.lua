--  Inspired by lspcontainer.nvim
-- https://github.com/lspcontainers/lspcontainers.nvim/blob/main/lua/lspcontainers/init.lua
local docker_cmd = function(name, image, workdir, network, docker_volume)
	if workdir == nil then
		workdir = vim.fn.getcwd()
	end

	local mnt_volume
	if docker_volume ~= nil then
		mnt_volume = "--volume=" .. docker_volume .. ":" .. workdir .. ":z"
	else
		mnt_volume = "--volume=" .. workdir .. ":" .. workdir .. ":z"
	end

	if network == nil then
		network = "none"
	end

	return {
		"docker",
		"run",
		"--rm",
		"--interactive",
		"--platform=linux/amd64",
		-- "--name=nvim-lsp-" .. name,
		"--network=" .. network,
		"--workdir=" .. workdir,
		mnt_volume,
		image,
	}
end

return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			-- Use a sub-list to run only the first available formatter
			javascript = { "prettier" },
			typescript = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			yaml = { "prettier" },
			html = { "prettier" },
			toml = { "prettier" },
			vue = { "prettier" },
			markdown = {
				"mdformat",
				"markdown-toc",
				"markdownlint",
			},
			css = { "stylelint", "prettier" },
		},
		formatters = {
			prettier = {
				command = table.concat(docker_cmd("prettier", "tmknom/prettier:latest"), " "),
			},
		},
	},
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
