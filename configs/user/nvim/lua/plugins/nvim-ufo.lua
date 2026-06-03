return {
    {
        "kevinhwang91/nvim-ufo",
        dependencies = "kevinhwang91/promise-async",
        "nvim-lua/plenary.nvim",
        event = "BufReadPost", -- Load when opening a file to maintain performance
        config = function()
            -- Neovim folder options required by UFO
            vim.o.foldcolumn = "1" -- Shows a visual column on the left side
            vim.o.foldlevel = 99 -- High default so files don't start fully collapsed
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            -- Keymaps to open and close folds globally
            vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
            vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })

            -- Set up the plugin to use Treesitter as the folding provider
            require("ufo").setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return { "treesitter", "indent" }
                end,
            })
        end,
    },
}
