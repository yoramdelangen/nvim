local function toggle_quickfix_menu()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            qf_exists = true
        end
    end
    if qf_exists == true then
        vim.cmd("cclose")
        return
    end
    if not vim.tbl_isempty(vim.fn.getqflist()) then
        vim.cmd("copen")
    else
        print("No quickfix lists available")
    end
end

local function call_silently(cmd)
    local success, err = pcall(function()
        vim.cmd(cmd)          -- Executes :cnext
        vim.cmd("normal! zz") -- Executes zz to center the cursor line in the screen
    end)

    if not success then
        print("No more items in the quickfix list")
    end
end

return {
    "folke/trouble.nvim",
    config = function()
        require("trouble").setup({
            icons = false,
        })

        local trouble = require('trouble')

        vim.keymap.set("n", "<leader>tt", function()
            trouble.toggle()
        end)

        vim.keymap.set("n", "[t", function()
            trouble.next({ skip_groups = true, jump = true });
        end)

        vim.keymap.set("n", "]t", function()
            trouble.previous({ skip_groups = true, jump = true });
        end)

        -- toggle stuff
        -- vim.keymap.set("n", "<leader>tw", function()
        --     trouble.toggle("workspace_diagnostics")
        -- end)
        -- vim.keymap.set("n", "<leader>td", function()
        --     trouble.toggle("document_diagnostics")
        -- end)
        -- vim.keymap.set("n", "<leader>tl", function()
        --     trouble.toggle("loclist")
        -- end)
        -- vim.keymap.set("n", "gR", function()
        --     trouble.toggle("lsp_references")
        -- end)

        vim.keymap.set("n", "<leader>q", toggle_quickfix_menu, { noremap = true })
        vim.keymap.set("n", "<C-[>", function()
            if trouble.is_open() then
                trouble.previous({ skip_groups = true, jump = true })
            else
                call_silently("cprev")
            end
        end, { noremap = true, silent = true })

        vim.keymap.set("n", "<C-]>", function()
            if trouble.is_open() then
                trouble.next({ skip_groups = true, jump = true })
            else
                call_silently("cnext")
            end
        end, { noremap = true, silent = true })
    end
}
