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
        "container",
        "run",
        "--interactive",
        "--rm",
        "--platform=linux/amd64",
        "--name=nvim-lsp-" .. name,
        "--network=" .. network,
        "--workdir=" .. workdir,
        mnt_volume,
        image
    }
end

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
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local lspconfig = require("lspconfig")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        -- setup Luasnip
        local luasnip = require("luasnip")
        require("luasnip.loaders.from_vscode").lazy_load()
        luasnip.config.setup({})

        local lspdocker = {
            intelephense = { image = "docker.io/lspcontainers/intelephense" },
            tsserver = { image = "docker.io/lspcontainers/tsserver" },
            volar = { image = "docker.io/lspcontainers/tsserver" },
            bashls = { image = "docker.io/lspcontainers/bash-language-server" },
            tailwindcss = { image = "docker.io/lspcontainers/tailwindcss-language-server" },
            yamlls = { image = "docker.io/lspcontainers/yaml-language-server" },
            -- lua_ls = { image = "docker.io/lspcontainers/lua-language-server" },
        }

        for lsp_name, opts in pairs(lspdocker) do
            lspconfig[lsp_name].setup {
                before_init = function(params)
                    params.processId = vim.NIL
                end,
                capabilities = capabilities,
                cmd = docker_cmd(lsp_name, opts.image),
            }
        end

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            automatic_installation = false,
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "gopls",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
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
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
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
    end
}
