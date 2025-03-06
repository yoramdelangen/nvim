return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			flavour = "auto",
			transparent_background = true,
			-- intergrations = {
			-- 	fidget = true,
			-- 	harpoon = true,
			--              mason = true,
			-- },
			background = {
				light = "latte",
				dark = "mocha",
			},
		})

		vim.cmd.colorscheme("catppuccin")
	end,
}
