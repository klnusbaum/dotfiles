return {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
        -- Comment
        require('mini.comment').setup()

        -- Starter
        require("mini.starter").setup()

        -- Sessions
        require("mini.sessions").setup()

        -- Surround
        require("mini.surround").setup()
    end
}
