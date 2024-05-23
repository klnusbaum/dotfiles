return {
    'nvimtools/none-ls.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local null_ls = require("null-ls")
        local buildifier_opts = {
            extra_filetypes = { "bazel", "starlark" },
        }

        null_ls.setup({
            sources = {
                null_ls.builtins.diagnostics.buildifier.with(buildifier_opts),
                null_ls.builtins.formatting.buildifier.with(buildifier_opts),
            },
        })
    end
}
