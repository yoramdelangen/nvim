vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

-- Netrw settings
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.opt.clipboard = "unnamed,unnamedplus"

-- commands
-- Make sure we can always exit properly!
local command = vim.api.nvim_create_user_command
command("WQ", "wq", {})
command("Wq", "wq", {})
command("W", "w", {})
command("Q", "q", {})

-- FILE TYPES
vim.filetype.add({
	extension = {
		conf = "conf",
		env = "dotenv",
		tiltfile = "tiltfile",
		Tiltfile = "tiltfile",
	},
	filename = {
		[".env"] = "dotenv",
		[".eslintrc.json"] = "jsonc", -- assuming nx project.json
		["project.json"] = "jsonc", -- assuming nx project.json
		[".yamlfmt"] = "yaml",
	},
	pattern = {
		["docker%-compose%.y.?ml"] = "yaml.docker-compose",
		["%.env%.[%w_.-]+"] = "dotenv",
		["tsconfig%."] = "jsonc",
	},
})
