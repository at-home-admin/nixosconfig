return {
    "serenevoid/kiwi.nvim",
    opts = {
        {
            name = "work",
            path = "work-wiki",
        },
        {
            name = "personal",
            path = "personal-wiki",
        },
    },
    keys = {
        { "<leader>ww", ':lua require("kiwi").open_wiki_index()<cr>', desc = "Open Wiki index" },
        {
            "<leader>wp",
            ':lua require("kiwi").open_wiki_index("personal")<cr>',
            desc = "Open index of personal wiki",
        },
        { "T", ':lua require("kiwi").todo.toggle()<cr>', desc = "Toggle Markdown Task" },
    },
    lazy = true,
}
