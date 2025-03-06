if vim.env.NVIM_PROFILE ~= nil then
	return {}
end

return {
	"LhKipp/nvim-nu",
	build = ":TSInstall nu",
	config = function()
		require("nu").setup({
			use_lsp_features = false,
		})
	end,
}
