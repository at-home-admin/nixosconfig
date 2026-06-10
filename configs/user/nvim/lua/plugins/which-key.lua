-- ============================================================================
-- Pure vim.api.nvim_feedkeys Table Integration using UPPERCASE <leader>T
-- ============================================================================

return {
    -- 1. Setup which-key.nvim
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            local wk = require("which-key")
            wk.setup({})

            -- Core helper to feed standard plugin keystrokes natively
            local function send_keys(keys)
                local codes = vim.api.nvim_replace_termcodes(keys, true, true, true)
                vim.api.nvim_feedkeys(codes, "m", true)
            end

            -- Snippet helper utilizing feedkeys to inject text and preserve raw insert points
            local function feed_snippet(text)
                local escape_text = vim.api.nvim_replace_termcodes("<ESC>a" .. text, true, true, true)
                vim.api.nvim_feedkeys(escape_text, "n", true)
            end

            wk.add({
                { "<leader>T", group = "+Table (Uppercase)" },
                {
                    "<leader>Ta",
                    function()
                        send_keys("<A-t>")
                    end,
                    desc = "Create Table (Interactive Prompt)",
                },

                -- Navigation via Feedkeys
                {
                    "<leader>Tc",
                    function()
                        send_keys("<TAB>")
                    end,
                    desc = "Next Cell",
                },
                {
                    "<leader>TC",
                    function()
                        send_keys("<S-TAB>")
                    end,
                    desc = "Previous Cell",
                },

                -- Row Operations via Feedkeys
                { "<leader>Tr", group = "+Row" },
                {
                    "<leader>Tri",
                    function()
                        send_keys("<A-k>")
                    end,
                    desc = "Insert Row Above",
                },
                {
                    "<leader>Tro",
                    function()
                        send_keys("<A-j>")
                    end,
                    desc = "Insert Row Below",
                },
                {
                    "<leader>Trk",
                    function()
                        send_keys("<A-S-k>")
                    end,
                    desc = "Move Row Up",
                },
                {
                    "<leader>Trj",
                    function()
                        send_keys("<A-S-j>")
                    end,
                    desc = "Move Row Down",
                },

                -- Column Operations via Feedkeys
                { "<leader>Tl", group = "+Column" },
                {
                    "<leader>Tli",
                    function()
                        send_keys("<A-h>")
                    end,
                    desc = "Insert Col Left",
                },
                {
                    "<leader>Tlo",
                    function()
                        send_keys("<A-l>")
                    end,
                    desc = "Insert Col Right",
                },
                {
                    "<leader>Tld",
                    function()
                        send_keys("<A-d>")
                    end,
                    desc = "Delete Column",
                },
                {
                    "<leader>Tlh",
                    function()
                        send_keys("<A-S-h>")
                    end,
                    desc = "Move Col Left",
                },
                {
                    "<leader>Tll",
                    function()
                        send_keys("<A-S-l>")
                    end,
                    desc = "Move Col Right",
                },

                -- ====================================================================
                -- Instant Snippets Menu via Feedkeys Text-Insertion
                -- ====================================================================
                { "<leader>Ts", group = "+Snippets" },

                -- 3-Row Blocks
                { "<leader>Ts3", group = "3-Row Templates" },
                {
                    "<leader>Ts33",
                    function()
                        feed_snippet(
                            "\n| Header 1 | Header 2 | Header 3 |\n| -------- | -------- | -------- |\n|          |          |          |\n|          |          |          |\n"
                        )
                    end,
                    desc = "Insert 3x3 Table",
                },
                {
                    "<leader>Ts34",
                    function()
                        feed_snippet(
                            "\n| Header 1 | Header 2 | Header 3 | Header 4 |\n| -------- | -------- | -------- | -------- |\n|          |          |          |          |\n|          |          |          |          |\n"
                        )
                    end,
                    desc = "Insert 3x4 Table",
                },
                {
                    "<leader>Ts35",
                    function()
                        feed_snippet(
                            "\n| Header 1 | Header 2 | Header 3 | Header 4 | Header 5 |\n| -------- | -------- | -------- | -------- | -------- |\n|          |          |          |          |          |\n|          |          |          |          |          |\n"
                        )
                    end,
                    desc = "Insert 3x5 Table",
                },

                -- 4-Row Blocks
                { "<leader>Ts4", group = "4-Row Templates" },
                {
                    "<leader>Ts42",
                    function()
                        feed_snippet(
                            "\n| Header 1 | Header 2 |\n| -------- | -------- |\n|          |          |\n|          |          |\n|          |          |\n"
                        )
                    end,
                    desc = "Insert 4x2 Table",
                },
                {
                    "<leader>Ts43",
                    function()
                        feed_snippet(
                            "\n| Header 1 | Header 2 | Header 3 |\n| -------- | -------- | -------- |\n|          |          |          |\n|          |          |          |\n|          |          |          |\n"
                        )
                    end,
                    desc = "Insert 4x3 Table",
                },
                {
                    "<leader>Ts44",
                    function()
                        feed_snippet(
                            "\n| Header 1 | Header 2 | Header 3 | Header 4 |\n| -------- | -------- | -------- | -------- |\n|          |          |          |          |\n|          |          |          |          |\n|          |          |          |          |\n"
                        )
                    end,
                    desc = "Insert 4x4 Table",
                },
                {
                    "<leader>Ts45",
                    function()
                        feed_snippet(
                            "\n| Header 1 | Header 2 | Header 3 | Header 4 | Header 5 |\n| -------- | -------- | -------- | -------- | -------- |\n|          |          |          |          |          |\n|          |          |          |          |          |\n|          |          |          |          |          |\n"
                        )
                    end,
                    desc = "Insert 4x5 Table",
                },

                -- 5-Row Blocks
                { "<leader>Ts5", group = "5-Row Templates" },
                {
                    "<leader>Ts52",
                    function()
                        feed_snippet(
                            "\n| Header 1 | Header 2 |\n| -------- | -------- |\n|          |          |\n|          |          |\n|          |          |\n|          |          |\n"
                        )
                    end,
                    desc = "Insert 5x2 Table",
                },
                {
                    "<leader>Ts53",
                    function()
                        feed_snippet(
                            "\n| Header 1 | Header 2 | Header 3 |\n| -------- | -------- | -------- |\n|          |          |          |\n|          |          |          |\n|          |          |          |\n|          |          |          |\n"
                        )
                    end,
                    desc = "Insert 5x3 Table",
                },
                {
                    "<leader>Ts54",
                    function()
                        feed_snippet(
                            "\n| Header 1 | Header 2 | Header 3 | Header 4 |\n| -------- | -------- | -------- | -------- |\n|          |          |          |          |\n|          |          |          |          |\n|          |          |          |          |\n|          |          |          |          |\n"
                        )
                    end,
                    desc = "Insert 5x4 Table",
                },
                {
                    "<leader>Ts55",
                    function()
                        feed_snippet(
                            "\n| Header 1 | Header 2 | Header 3 | Header 4 | Header 5 |\n| -------- | -------- | -------- | -------- | -------- |\n|          |          |          |          |          |\n|          |          |          |          |          |\n|          |          |          |          |          |\n|          |          |          |          |          |\n"
                        )
                    end,
                    desc = "Insert 5x5 Table",
                },
            })
        end,
    },

    -- 2. Setup table-nvim
    {
        "SCJangra/table-nvim",
        ft = { "markdown" },
        config = function()
            -- Leave mappings active so our feedkeys pipeline can securely leverage them
            require("table-nvim").setup({
                padd_column_separators = true,
            })

            -- Autocommand running an immediate feedkey sequence to update table layout instantly
            local table_group = vim.api.nvim_create_augroup("TableNvimFormat", { clear = true })
            vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePre" }, {
                group = table_group,
                pattern = "*.md",
                callback = function()
                    local sync_keys = vim.api.nvim_replace_termcodes("<TAB><S-TAB>", true, true, true)
                    vim.api.nvim_feedkeys(sync_keys, "n", true)
                end,
            })
        end,
    },
}
