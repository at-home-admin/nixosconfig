return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",

    dependencies = { "nvim-lua/plenary.nvim", "nosduco/remote-sshfs.nvim", "jvgrootveld/telescope-zoxide" },

    opts = {
        extensions_list = { "remote-sshfs", "themes", "terms", "zoxide" },
        extensions = {
            zoxide = {
                prompt_title = "[Walking on the shoulders of TJ}", -- Title of the zoxide prompt
            },
        },
    },
}
