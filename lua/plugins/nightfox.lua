return {
    "EdenEast/nightfox.nvim",
    config = function()
        require("nightfox").setup({
            options = {
                transparent = true,
                styles = {
                    comments = "italic",
                    keywords = "bold",
                    types = "italic,bold",
                }
            },
            groups = {
                all = {
                    NormalFloat = { bg = "none" },
                    WhichKeyFloat = { bg = "none" },
                },
            },

        })
        vim.cmd("colorscheme carbonfox")
    end,
}
