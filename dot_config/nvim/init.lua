-- helper functions
local kn_map = require("keymappings").kn_map
local kn_l_map = require("keymappings").kn_l_map
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

kn_l_map("ot", function()
    vim.cmd("vsplit | term")
end)

-- vim config editing convenience
kn_l_map("ev", function()
    vim.cmd("vsplit $MYVIMRC")
end)
kn_l_map("sv", function()
    vim.cmd("source $MYVIMRC")
    vim.notify('Reloaded $MYVIMRC')
end)

-- Netrw settings
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 1
kn_l_map("f", function()
    vim.cmd('Vexplore')
end)

-- spelling shortcuts
kn_l_map("ss", function()
    vim.opt.spell = true
end)
kn_l_map("ns", function()
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

        kn_map('gd', vim.lsp.buf.definition, opts)
        kn_map('K', vim.lsp.buf.hover, opts)
        kn_map('grr', vim.lsp.buf.rename, opts)
        kn_map('grf', vim.lsp.buf.references, opts)
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
kn_l_map('ggu', function()
    vim.cmd("Git add --update")
    vim.notify('git added all updated files')
end)
kn_l_map('gga', function() vim.cmd("Git commit --amend --no-edit") end)
kn_l_map('ggc', function()
    vim.ui.input({ prompt = 'Commit message: ' }, function(input)
        if input then
            vim.cmd('Git commit -m "' .. input .. '"')
        else
            vim.notify("Commit aborted")
        end
    end)
end)
kn_l_map('ggrc', function() vim.cmd("Git rebase --continue") end)
kn_l_map('ggpu', function() vim.cmd("Git push") end)
kn_l_map('ggs', vim.cmd.Git)

-- Arc customizations
kn_l_map("ad", create_diff)
kn_l_map('ud', function()
    vim.cmd("Git add --update")
    vim.cmd("Git commit --amend --no-edit")
    vim.ui.input({ prompt = 'Diff message: ' }, function(input)
        vim.cmd('vs | term arc diff HEAD^ -m "' .. input .. '"')
    end)
end)

-- Telescope
local tele = require('telescope.builtin')
kn_l_map('tf', function() tele.find_files() end)
kn_l_map('th', function() tele.help_tags() end)
kn_l_map('tg', function() tele.live_grep() end)
kn_l_map('tb', function() tele.git_branches() end)
kn_l_map('tp', function() tele.resume() end)
kn_l_map('te', function() tele.buffers() end)
kn_l_map('ts', function() tele.grep_string() end)

-- Language specific keymaps
kn_l_map('cr', function()
    vim.cmd.vsplit()
    vim.cmd.term("cargo run")
end)
