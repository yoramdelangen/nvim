--  Inspired by lspcontainer.nvim
-- https://github.com/lspcontainers/lspcontainers.nvim/blob/main/lua/lspcontainers/init.lua
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
-- 		"--interactive",
-- 		"--platform=linux/amd64",
-- 		-- "--name=nvim-lsp-" .. name,
-- 		"--network=" .. network,
-- 		"--workdir=" .. workdir,
-- 		mnt_volume,
-- 		image,
-- 	}
-- end
--
return {
	"neovim/nvim-lspconfig",

	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
	},

	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local lspconfig = require("lspconfig")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		-- setup Luasnip
		local luasnip = require("luasnip")
		require("luasnip.loaders.from_vscode").lazy_load()
		luasnip.config.setup({})

		-- lspconfig.svelte.setup({
		-- 	capabilities = capabilities,
		-- 	cmd = { "bunx", "--bun", "svelteserver", "--stdio" },
		-- })
		-- lspconfig.ts_ls.setup({
		-- 	capabilities = capabilities,
		-- 	cmd = { "bunx", "--bun", "typescript-language-server", "--stdio" },
		-- })
		-- lspconfig.volar.setup({
		-- 	capabilities = capabilities,
		-- 	cmd = { "bunx", "--bun", "vue-language-server", "--stdio" },
		-- })
		-- lspconfig.bashls.setup({
		-- 	capabilities = capabilities,
		-- 	cmd = { "bunx", "--bun", "bash-language-server", "--stdio" },
		-- })
		-- lspconfig.intelephense.setup({
		-- 	capabilities = capabilities,
		-- 	cmd = { "bunx", "--bun", "intelephense", "--stdio" },
		-- })

		local util = require("lspconfig.util")
		local function get_typescript_server_path(root_dir)
			local global_ts = os.getenv("HOME") .. "/.bun/install/global/node_modules/typescript/lib"
			print(global_ts)

			local found_ts = ""
			local function check_dir(path)
				found_ts = util.path.join(path, "node_modules", "typescript", "lib")
				if util.path.exists(found_ts) then
					return path
				end
			end
			if util.search_ancestors(root_dir, check_dir) then
				return found_ts
			else
				return global_ts
			end
		end

		-- for lsp_name, opts in pairs(lspdocker) do
		-- 	lspconfig[lsp_name].setup({
		-- 		before_init = function(params)
		-- 			params.processId = vim.NIL
		-- 		end,
		-- 		capabilities = capabilities,
		-- 		cmd = docker_cmd(lsp_name, opts.image),
		-- 	})
		-- end

		-- manual installs, not able to install via Mason
		if vim.env.NVIM_PROFILE ~= nil then
			lspconfig.nushell.setup({
				capabilities = capabilities,
			})
		end

		require("fidget").setup({})
		require("mason").setup()
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,

				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = { version = "Lua 5.1" },
								diagnostics = {
									globals = { "vim", "it", "describe", "before_each", "after_each" },
								},
							},
						},
					})
				end,

				["volar"] = function()
					lspconfig.volar.setup({
						capabilities = capabilities,
						-- filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
						on_new_config = function(new_config, new_root_dir)
							new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
						end,
					})
				end,

				["ts_ls"] = function()
					local global_ts = os.getenv("HOME") .. "/.bun/install/global/node_modules/@vue/typescript-plugin"

					lspconfig.ts_ls.setup({
						capabilities = capabilities,
						init_options = {
							plugins = {
								{
									name = "@vue/typescript-plugin",
									location = global_ts,
									languages = { "javascript", "typescript", "vue" },
								},
							},
						},
						filetypes = {
							"javascript",
							"typescript",
							"typescriptreact",
							"vue",
						},
					})
				end,

				["rust_analyzer"] = function()
					lspconfig.rust_analyzer.setup({
						capabilities = capabilities,
						-- settings = {
						-- 	procMacro = {
						-- 		ignored = {
						-- 			leptos_macro = {
						-- 				"component",
						-- 				"server",
						-- 			},
						-- 		},
						-- 	},
						-- },
						-- diagnostic = {
						-- 	refreshSupport = false,
						-- },
					})
				end,
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
			}, {
				{ name = "buffer" },
			}),
		})

		-- require("lsp_lines").setup()

		vim.diagnostic.config({
			-- virtual_text = false,
			-- update_in_insert = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end,
}
