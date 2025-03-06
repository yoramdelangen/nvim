return {
	"https://codeberg.org/esensar/nvim-dev-container",
	dependencies = "nvim-treesitter/nvim-treesitter",
	opts = {
		autocommands = {
			-- can be set to true to automatically start containers when devcontainer.json is available
			init = true,
			-- can be set to true to automatically remove any started containers and any built images when exiting vim
			clean = true,
			-- can be set to true to automatically restart containers when devcontainer.json file is updated
			update = true,
		},
	},
}
