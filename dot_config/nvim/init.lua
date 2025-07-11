-- helper functions
local Augroup = require('kautocmd').Augroup
local create_diff = require('phab').create_diff

local personal_group = Augroup:new('personal')

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
vim.opt.spell = true
vim.g.mapleader = ' '

require('lazy-init')
require('lualine').setup()

-- Neovide settings
if vim.g.neovide
then
    vim.g.neovide_fullscreen = true
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_transparency = 0.8
end

-- Copy/Paste settings
personal_group:add_cmd('TextYankPost', {
    pattern = '*',
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.keymap.set('n', '<leader>y', '"+y')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>lg', function()
    local full_filepath = vim.fn.expand('%:p')
    local git_root = vim.fs.root(full_filepath, '.git')
    if git_root == nil or git_root == '' then
        vim.notify("Not in git repository (no .git directory found)", vim.log.levels.WARN)
        return
    end
    local relative_path = vim.fs.relpath(git_root, full_filepath)
    vim.fn.setreg('+', relative_path)
    vim.notify("Copied relative path: " .. relative_path, vim.log.levels.INFO)
end)

-- terminal customizations
personal_group:add_cmd('TermOpen', {
    pattern = '*',
    callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.cmd.startinsert()
        vim.opt.spell = false
    end,
})
personal_group:add_cmd('WinEnter', {
    pattern = 'term://*',
    callback = function() vim.cmd.startinsert() end,
})

vim.keymap.set('n', '<leader>!', ":vert term ")

vim.keymap.set('t', '<c-\\><c-w>', '<c-\\><c-n><c-w><c-w>')
vim.keymap.set('t', '<c-\\><c-h>', '<c-\\><c-n><c-w>h')
vim.keymap.set('t', '<c-\\><c-j>', '<c-\\><c-n><c-w>j')
vim.keymap.set('t', '<c-\\><c-k>', '<c-\\><c-n><c-w>k')
vim.keymap.set('t', '<c-\\><c-l>', '<c-\\><c-n><c-w>l')
vim.keymap.set('t', '<c-\\><c-t>', '<c-\\><c-n>gt')

vim.keymap.set('n', '<leader>ot', function()
    vim.cmd.vsplit()
    vim.cmd.term()
end)
vim.keymap.set('n', '<leader>od', ':vsplit term://%:p:h//zsh<CR>')

-- vim config editing convenience
vim.keymap.set('n', '<leader>ev', function()
    vim.cmd.vsplit('$MYVIMRC')
end)
vim.keymap.set('n', '<leader>sv', function()
    vim.cmd.source('$MYVIMRC')
    vim.notify('Reloaded $MYVIMRC')
end)

-- Netrw settings
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 1

-- lsp settings
vim.lsp.inlay_hint.enable(true)

vim.keymap.set('n', ']x', function()
    vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })

vim.keymap.set('n', '[x', function()
    vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })

local no_autofmt = { json = true }
local autofmt_status = {
    enabled = true
}
vim.keymap.set('n', '<leader>a', function()
    autofmt_status.enabled = not autofmt_status.enabled
    vim.notify("Autoformat: " .. (autofmt_status.enabled and "enabled" or "disabled"))
end, { desc = "toggle autoformat" })

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(args)
        local opts = { buffer = args.buf }

        vim.keymap.set('n', 'gf', vim.lsp.buf.format, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'grr', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', 'grf', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, opts)


        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = args.buf,
            callback = function()
                local ft = vim.bo.filetype
                if no_autofmt[ft] == nil and autofmt_status.enabled then
                    vim.lsp.buf.format { async = false, id = args.data.client_id }
                end
            end,
        })
    end
})

local default_capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
lspconfig['gopls'].setup({ capabilities = default_capabilities })
lspconfig['pylsp'].setup({ capabilities = default_capabilities })
lspconfig['dockerls'].setup({ capabilities = default_capabilities })
lspconfig['rust_analyzer'].setup({ capabilities = default_capabilities })
lspconfig['ts_ls'].setup({ capabilities = default_capabilities })
lspconfig['bashls'].setup({ capabilities = default_capabilities })
lspconfig['cssls'].setup({ capabilities = default_capabilities })
lspconfig['html'].setup({ capabilities = default_capabilities })
lspconfig['jsonls'].setup({ capabilities = default_capabilities })
lspconfig['tailwindcss'].setup({ capabilities = default_capabilities })
lspconfig['templ'].setup({ capabilities = default_capabilities })
lspconfig['terraformls'].setup({ capabilities = default_capabilities })
lspconfig['yamlls'].setup({ capabilities = default_capabilities })
lspconfig['lua_ls'].setup({
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
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false, -- turn off to avoid third part check prompt
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})

-- Arc customizations
vim.keymap.set('n', '<leader>ad', create_diff)
vim.keymap.set('n', '<leader>ud', function()
    vim.cmd('Git add --update')
    vim.cmd('Git commit --amend --no-edit')
    vim.ui.input({ prompt = 'Diff message: ' }, function(input)
        vim.cmd('vs | term arc diff HEAD^ -m "' .. input .. '"')
    end)
end)

-- Telescope
local tele = require('telescope.builtin')
local mini_sessions = require('mini.sessions')
vim.keymap.set('n', '<leader>tf', tele.find_files)
vim.keymap.set('n', '<leader>th', tele.help_tags)
vim.keymap.set('n', '<leader>tg', tele.live_grep)
vim.keymap.set('n', '<leader>tb', tele.git_branches)
vim.keymap.set('n', '<leader>tp', tele.resume)
vim.keymap.set('n', '<leader>te', tele.buffers)
vim.keymap.set('n', '<leader>tS', tele.grep_string)
vim.keymap.set('n', '<leader>tt', tele.treesitter)
vim.keymap.set('n', '<leader>tc', tele.colorscheme)
vim.keymap.set('n', '<leader>ts', function()
    mini_sessions.select('read', {})
end)
vim.keymap.set('n', '<leader>td', function()
    mini_sessions.select('delete', {})
end)

-- Random specific keymaps
vim.keymap.set('n', '<leader>ma', vim.cmd.make, { desc = 'run make' })
vim.keymap.set('n', '<leader>ca', function()
        vim.cmd.vsplit()
        vim.cmd('term chezmoi apply')
    end,
    { desc = 'apply chezmoi dotfiles' })
vim.keymap.set('n', '<leader>cmx', function()
        vim.cmd('!chmod u+x %')
    end,
    { desc = 'make file in current buffer executable' })
vim.keymap.set('n', '<leader>hr', function()
        vim.opt.cmdheight = 1
    end,
    { desc = 'reset command line height' })

-- Set default colorscheme
vim.cmd.colorscheme 'kanagawa'

-- Optionally include additional, work-specific config
local work_vim_dir = vim.fs.joinpath(vim.env.HOME, "kopt", "work", "nvim")
if vim.fn.finddir(work_vim_dir) ~= "" then
    vim.opt.runtimepath:append(work_vim_dir)
    require('work')
end
