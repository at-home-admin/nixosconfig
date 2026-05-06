return {
    {
        "tpope/vim-dadbod",
        dependencies = {
            "kristijanhusak/vim-dadbod-ui",
            "kristijanhusak/vim-dadbod-completion",
        },
        config = function()
            -- Optional: Configure where to save UI queries
            vim.g.db_ui_save_location = "~/.config/nvim/db_ui"
            vim.g.db_ui_show_help = 0
            vim.g.db_ui_use_nerd_fonts = 1
        end,
    },
}
