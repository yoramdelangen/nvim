return {
  'stevearc/oil.nvim',
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },

  config = function()
	  require("oil").setup({
				view_options = {
					show_hidden = true,
				},
			})


	  vim.keymap.set("n", "<leader>pv", "<CMD>Oil<cr>", { desc = "Neovim File Explorer" })
end 
}
