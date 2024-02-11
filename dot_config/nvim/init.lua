-- helper functions
local Augroup = require("kautocmd").Augroup
local create_diff = require("phab").create_diff

local personal_group = Augroup:new("personal")

-- Misc options settings
vim.opt.nu = true
vim.opt.rnu = true
vim.opt.mouse = a
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.g.mapleader = " "

require('lazy-init')
require('lualine').setup()

-- Neovide settings
if vim.g.neovide
then
    vim.g.neovide_fullscreen = true
    vim.g.neovide_hide_mouse_when_typing = true
end

-- Copy/Paste settings
personal_group:add_cmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- terminal customizations
personal_group:add_cmd("TermOpen", {
    pattern = "*",
    callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.cmd "startinsert"
    end,
})
personal_group:add_cmd("WinEnter", {
    pattern = "term://*",
    callback = function() vim.cmd "startinsert" end,
})

vim.keymap.set('t', "<c-\\><c-w>", "<c-\\><c-n><c-w><c-w>")
vim.keymap.set('t', "<c-\\><c-h>", "<c-\\><c-n><c-w>h")
vim.keymap.set('t', "<c-\\><c-j>", "<c-\\><c-n><c-w>j")
vim.keymap.set('t', "<c-\\><c-k>", "<c-\\><c-n><c-w>k")
vim.keymap.set('t', "<c-\\><c-l>", "<c-\\><c-n><c-w>l")
vim.keymap.set('t', "<c-\\><c-t>", "<c-\\><c-n>gt")

vim.keymap.set('n', "<leader>ot", function()
    vim.cmd("vsplit | term")
end)

-- vim config editing convenience
vim.keymap.set('n', "<leader>ev", function()
    vim.cmd("vsplit $MYVIMRC")
end)
vim.keymap.set('n', "<leader>sv", function()
    vim.cmd("source $MYVIMRC")
    vim.notify('Reloaded $MYVIMRC')
end)

-- Netrw settings
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 1
vim.keymap.set('n', "<leader>f", function()
    vim.cmd('Vexplore')
end)

-- spelling shortcuts
vim.keymap.set('n', "<leader>ss", function()
    vim.opt.spell = true
end)
vim.keymap.set('n', "<leader>ns", function()
    vim.opt.spell = false
end)

-- lsp settings
personal_group:add_cmd("BufWritePre", {
    pattern = { '*.bzl', '*.bazel', '*.star', '*.rs', '*.go', '*.lua', '*.js', '*.py' },
    callback = function()
        vim.lsp.buf.format()
    end,
})

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'grr', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', 'grf', vim.lsp.buf.references, opts)
    end
})

local default_capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require("lspconfig")
lspconfig["gopls"].setup({ capabilities = default_capabilities })
lspconfig["pylsp"].setup({ capabilities = default_capabilities })
lspconfig["dockerls"].setup({ capabilities = default_capabilities })
lspconfig["rust_analyzer"].setup({ capabilities = default_capabilities })
lspconfig["tsserver"].setup({ capabilities = default_capabilities })
lspconfig["bashls"].setup({ capabilities = default_capabilities })
lspconfig["lua_ls"].setup({
    capabilities = default_capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false, -- turn off to avoid third part check prompt
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})


-- Fugitive (git) customizations
vim.keymap.set('n', '<leader>ggu', function()
    vim.cmd("Git add --update")
    vim.notify('git added all updated files')
end)
vim.keymap.set('n', '<leader>gga', function() vim.cmd("Git commit --amend --no-edit") end)
vim.keymap.set('n', '<leader>ggc', function()
    vim.ui.input({ prompt = 'Commit message: ' }, function(input)
        if input then
            vim.cmd('Git commit -m "' .. input .. '"')
        else
            vim.notify("Commit aborted")
        end
    end)
end)
vim.keymap.set('n', '<leader>ggrc', function() vim.cmd("Git rebase --continue") end)
vim.keymap.set('n', '<leader>ggpu', function() vim.cmd("Git push") end)
vim.keymap.set('n', '<leader>ggs', vim.cmd.Git)

-- Arc customizations
vim.keymap.set('n', "<leader>ad", create_diff)
vim.keymap.set('n', '<leader>ud', function()
    vim.cmd("Git add --update")
    vim.cmd("Git commit --amend --no-edit")
    vim.ui.input({ prompt = 'Diff message: ' }, function(input)
        vim.cmd('vs | term arc diff HEAD^ -m "' .. input .. '"')
    end)
end)

-- Telescope
local tele = require('telescope.builtin')
vim.keymap.set('n', '<leader>tf', function() tele.find_files() end)
vim.keymap.set('n', '<leader>th', function() tele.help_tags() end)
vim.keymap.set('n', '<leader>tg', function() tele.live_grep() end)
vim.keymap.set('n', '<leader>tb', function() tele.git_branches() end)
vim.keymap.set('n', '<leader>tp', function() tele.resume() end)
vim.keymap.set('n', '<leader>te', function() tele.buffers() end)
vim.keymap.set('n', '<leader>ts', function() tele.grep_string() end)

-- Language specific keymaps
vim.keymap.set('n', '<leader>cr', function()
    vim.cmd.vsplit()
    vim.cmd.term("cargo run")
end)
