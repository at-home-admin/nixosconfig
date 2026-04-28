return {
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            {

                mode = "n",
                "-",
                function()
                    require("oil").open()
                end,
                desc = "[F]ormat buffer",
            },
        },
        opts = {
            default_file_explorer = true,
            skip_confirm_for_simple_edits = true,
            view_options = {
                show_hidden = true,
                is_always_hidden = function(name, _)
                    return name == "node_modules" or name == ".git"
                end,
            },
            keymaps = {
                ["<c-c>"] = false,
                ["q"] = "actions.close",
            },
        },
    },
}
