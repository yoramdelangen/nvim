return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            -- Use a sub-list to run only the first available formatter
            javascript = { "biome" },
            typescript = { "biome" },
            json = { "biome" },
            jsonc = { "biome" },
            yaml = { "biome" },
            html = { "biome" },
            toml = { "biome" },
            vue = { "biome" },
            markdown = {
                "mdformat",
                "markdown-toc",
                "markdownlint",
            },
            css = { "stylelint", "boime" },
        },
    },
    init = function()
        -- If you want the formatexpr, here is the place to set it
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}
