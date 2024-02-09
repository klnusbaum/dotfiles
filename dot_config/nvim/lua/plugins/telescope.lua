return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
        local telescope = require('telescope')
        local themes = require('telescope.themes')
        telescope.setup({
            extensions = {
                ["ui-select"] = {
                    themes.get_dropdown(),
                },
            },
        })
        telescope.load_extension('ui-select')
    end
}
