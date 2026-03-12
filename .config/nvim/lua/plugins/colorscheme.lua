return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            -- enable the colorscheme
            vim.cmd.colorscheme "catppuccin"
        end,
        opts = {
            flavour = "mocha",
            lsp_styles = {
                underlines = {
                    errors = { "undercurl" },
                    hints = { "undercurl" },
                    warnings = { "undercurl" },
                    information = { "undercurl" },
                },
            },
            auto_integrations = true,
        },
    },
}
