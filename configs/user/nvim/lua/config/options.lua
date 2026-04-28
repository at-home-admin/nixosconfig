-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Auto update plugins at startup
-- Tried to add this vimenter autocmd in the autocmds.lua file but it was never
-- triggered, this is because if I understand correctly Lazy.nvim delays the
-- loading of autocmds.lua until after VeryLazy or even after VimEnter
-- The fix is to add the autocmd to a file that’s loaded before VimEnter,
-- such as options.lua
-- https://github.com/LazyVim/LazyVim/issues/2592#issuecomment-2015093693
-- Only upate if there are updates
-- https://github.com/folke/lazy.nvim/issues/702#issuecomment-1903484213
local function augroup(name)
    return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end
vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup("autoupdate"),
    callback = function()
        if require("lazy.status").has_updates then
            require("lazy").update({ show = false })
        end
    end,
})

-- I added `localoptions` to save the language spell settings, otherwise, the
-- language of my markdown documents was not remembered if I set it to spanish
-- or to both en,es
-- See the help for `sessionoptions`
-- `localoptions`: options and mappings local to a window or buffer
-- (not global values for local options)
--
-- The plugin that saves the session information is
-- https://github.com/folke/persistence.nvim and comes enabled in the
-- lazyvim.org distro lamw25wmal
--
-- These sessionoptions come from the lazyvim distro, I just added localoptions
-- https://www.lazyvim.org/configuration/general
vim.opt.sessionoptions = {
    "buffers",
    "curdir",
    "tabpages",
    "winsize",
    "help",
    "globals",
    "skiprtp",
    "folds",
    "localoptions",
}

-- Most of my files have 2 languages, spanish and english, so even if I set the
-- language to spanish, I always add some words in English to my documents, so
-- it's annoying to be adding those to the spanish dictionary
-- vim.opt.spelllang = { "en,es" }

-- I mainly type in english, if I set it to both above, files in English get a
-- bit confused and recognize words in spanish, just for spanish files I need to
-- set it to both
vim.opt.spelllang = { "en" }

-- -- My cursor was working fine, not  sure why it stopped working in wezterm, so
-- -- the config below fixed it
-- --
-- -- NOTE: I think the issues with my cursor started happening when I moved to wezterm
-- -- and started using the "wezterm" terminfo file, when in wezterm, I switched to
-- -- the "xterm-kitty" terminfo file, and the cursor is working great without
-- -- the configuration below. Leaving the config here as reference in case it
-- -- needs to be tested with another terminal emulator in the future
-- --
-- vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"
