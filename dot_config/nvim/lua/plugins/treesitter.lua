return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                'vimdoc', 'javascript', 'typescript', 'c', 'lua', 'rust',
                'jsdoc', 'bash', 'go', 'cmake', 'cpp', 'css', 'fennel',
                'html', 'latex', 'make', 'proto', 'python', 'sql',
                'toml', 'yaml', 'markdown',
            },
            auto_install = true,
            highlight = {
                enabled = true,
            },
        })
    end,
}
