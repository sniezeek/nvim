return {
    {
        "numToStr/Comment.nvim",
        event = "BufReadPost",
        config = function()
            require("Comment").setup({
                padding = true,
                sticky = true,
                ignore = "^$",
                mappings = {
                    basic = true,
                    extra = true,
                },
                pre_hook = nil,
                post_hook = nil,
            })
        end,
    }
}
