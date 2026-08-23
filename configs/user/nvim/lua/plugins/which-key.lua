return {
    {
        "folke/which-key.nvim",
        lazy = false,
        config = function()
            local wk = require("which-key")

            wk.setup({
                triggers = {
                    { "<leader>", mode = { "n", "v" } },
                },
            })

            local mermaid_group = vim.api.nvim_create_augroup("MermaidWhichKeyMappings", { clear = true })

            local function register_mermaid_mappings(buf)
                wk.add({
                    {
                        "<leader>m",
                        group = "Mermaid",
                        mode = "n",
                        buffer = buf,
                    },
                    {
                        "<leader>mp",
                        "<cmd>MermaidPreview<CR>",
                        desc = "Preview",
                        mode = "n",
                        buffer = buf,
                    },
                    {
                        "<leader>mf",
                        "<cmd>MermaidFormat<CR>",
                        desc = "Format",
                        mode = "n",
                        buffer = buf,
                    },
                    {
                        "<leader>mr",
                        "<cmd>MermaidRender<CR>",
                        desc = "Render",
                        mode = "n",
                        buffer = buf,
                    },
                    {
                        "<leader>mc",
                        "<cmd>MermaidCopyURL<CR>",
                        desc = "Copy URL",
                        mode = "n",
                        buffer = buf,
                    },
                    {
                        "<leader>mx",
                        "<cmd>MermaidPreviewStop<CR>",
                        desc = "Stop Preview",
                        mode = "n",
                        buffer = buf,
                    },
                })
            end

            vim.api.nvim_create_autocmd("FileType", {
                group = mermaid_group,
                pattern = "mermaid",
                callback = function(event)
                    register_mermaid_mappings(event.buf)
                end,
            })

            -- Handles Mermaid buffers that already existed before this config loaded.
            vim.api.nvim_create_autocmd("BufEnter", {
                group = mermaid_group,
                pattern = "*",
                callback = function(event)
                    if vim.bo[event.buf].filetype == "mermaid" then
                        register_mermaid_mappings(event.buf)
                    end
                end,
            })
        end,
    },

    {
        "SCJangra/table-nvim",
        ft = { "markdown" },
        config = function()
            require("table-nvim").setup({
                padd_column_separators = true,
            })

            local table_group = vim.api.nvim_create_augroup("TableNvimFormat", { clear = true })

            vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePre" }, {
                group = table_group,
                pattern = "*.md",
                callback = function()
                    local sync_keys = vim.api.nvim_replace_termcodes("<Tab><S-Tab>", true, true, true)

                    vim.api.nvim_feedkeys(sync_keys, "n", true)
                end,
            })
        end,
    },
}
