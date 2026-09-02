return {
    "lancekrogers/mermaider.nvim",
    dependencies = { "3rd/image.nvim" },
    ft = { "mmd", "mermaid", "markdown" },
    config = function()
        require("mermaider").setup({
            mermaider_cmd = "npx -y -p @mermaid-js/mermaid-cli mmdc -i {{IN_FILE}} -o {{OUT_FILE}}.png -s 3",
            temp_dir = vim.fn.expand("$HOME/.cache/mermaider"),
            auto_render = true,
            auto_render_on_open = true,
            auto_preview = true,
            throttle_delay = 500,
            inline_render = true, -- false = split
            split_direction = "vertical",
            split_width = 50,
            theme = "forest", -- dark | light | forest | neutral
            background_color = "#1e1e2e",
            css_file = nil,
            mermaid_config_file = nil,
        })
    end,
}
