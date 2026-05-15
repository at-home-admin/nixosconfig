return {
    "mfussenegger/nvim-lint",
    opts = {
        -- Map markdown filetype to the linter
        linters_by_ft = {
            markdown = { "markdownlint-cli2" },
        },
        -- Configure the linter arguments
        linters = {
            ["markdownlint-cli2"] = {
                args = {
                    "--config",
                    vim.fn.expand(".markdownlint-cli2.yaml"), -- Path to your config file
                    "--", -- Signal end of arguments
                },
            },
        },
    },
}
