-- helper functions
local fn = vim.fn
local kt_map = require("keymappings").kt_map
local kn_map = require("keymappings").kn_map
local kn_l_map = require("keymappings").kn_l_map
local kv_l_map = require("keymappings").kv_l_map
local Augroup = require("kautocmd").Augroup
local ext_opts = require("options").ext_opts
local current_buf_contents = require("kbufhelpers").current_buf_contents
local set_current_buf_contents = require("kbufhelpers").set_current_buf_contents
local create_diff = require("phab").create_diff

local personal_group = Augroup:new("personal")

-- Misc options settings
vim.opt.nu=true
vim.opt.rnu=true
vim.opt.mouse=a
vim.opt.tabstop=4
vim.opt.shiftwidth=4
vim.opt.expandtab=true
vim.opt.smartindent=true
vim.opt.termguicolors=true
vim.opt.splitbelow=true
vim.opt.splitright=true
vim.g.mapleader=" "

require('lazy-init')
require('lualine').setup()

-- Neovide settings
if vim.g.neovide
then
    vim.g.neovide_fullscreen=true
    vim.g.neovide_hide_mouse_when_typing=true
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

kt_map("<c-\\><c-w>","<c-\\><c-n><c-w><c-w>")
kt_map("<c-\\><c-h>","<c-\\><c-n><c-w>h")
kt_map("<c-\\><c-j>","<c-\\><c-n><c-w>j")
kt_map("<c-\\><c-k>","<c-\\><c-n><c-w>k")
kt_map("<c-\\><c-l>","<c-\\><c-n><c-w>l")

kn_l_map("ot", function()
  vim.api.nvim_command("vsplit | term")
end)

-- vim config editing convenience
kn_l_map("ev", function ()
  vim.api.nvim_command("vsplit $MYVIMRC")
end)
kn_l_map("sv", function ()
  vim.api.nvim_command("source $MYVIMRC")
  vim.notify('Reloaded $MYVIMRC')
end)

-- Netrw settings
vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 1
kn_l_map("f", function()
  vim.api.nvim_command('Vexplore')
end)

-- spelling shortcuts
kn_l_map("ss", function()
  vim.opt.spell = true
end)
kn_l_map("ns", function()
  vim.opt.spell = false
end)

-- nvim-cmp
local cmp = require('cmp')
cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'buffer' },
      { name = 'emoji' },
      { name = 'path' },
      { name = 'luasnip' },
    })
})

-- lsp settings
local function autofmt()
    vim.lsp.buf.formatting_sync(nil, 3000)
end
personal_group:add_cmd("BufWritePre", {
  pattern = {'*.rs', '*.go', '.*lua'},
  callback = autofmt,
})

local lsp_on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap=true, silent=true, buffer=bufnr}
  kn_map('gd', vim.lsp.buf.definition, opts)
  kn_map('K', vim.lsp.buf.hover, opts)
  kn_map('grr', vim.lsp.buf.rename, opts)
  kn_map('grf', vim.lsp.buf.references, opts)
end

local lsp_flags = {
  -- Don't spam LSP with changes. Wait a second between each.
  debounce_text_changes = 1000,
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local standard_lsp_config = {
  on_attach = lsp_on_attach,
  flags = lsp_flags,
  capabilities = capabilities,
}

local lua_lsp_settings = {
  Lua = {
    runtime = {
      -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
      version = 'LuaJIT',
    },
    diagnostics = {
      -- Get the language server to recognize the `vim` global
      globals = {'vim'},
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
}

local language_servers = {
  gopls = {
    cmd = {'gopls', '-remote=auto'},
  },
  lua_ls = {
    settings = lua_lsp_settings,
  },
  pylsp = {},
  dockerls = {},
  rust_analyzer = {},
}

for lsp_name, opts in pairs(language_servers) do
  local all_opts = ext_opts(standard_lsp_config, opts)
  require('lspconfig')[lsp_name].setup(all_opts)
end

-- Fugitive (git) customizations
kn_l_map('ggu', function()
  vim.api.nvim_command("Git add --update")
  vim.notify('git added all updated files')
end)
kn_l_map('gga', function() vim.api.nvim_command("Git commit --amend --no-edit") end)
kn_l_map('ggc', function()
  vim.ui.input({ prompt = 'Commit message: '}, function(input)
    if input then
      vim.api.nvim_command('Git commit -m "' .. input .. '"')
    else
      vim.notify("Commit aborted")
    end
  end)
end)
kn_l_map('ggrc', function() vim.api.nvim_command("Git rebase --continue") end)

-- Arc customizations
kn_l_map("ad", create_diff)
kn_l_map('ud', function()
  vim.api.nvim_command("Git add --update")
  vim.api.nvim_command("Git commit --amend --no-edit")
  vim.ui.input({ prompt = 'Diff message: '}, function(input)
    vim.api.nvim_command('vs | term arc diff HEAD^ -m "' .. input .. '"')
  end)
end)

-- Bazel/Starlark
personal_group:add_cmd("BufWritePre", {
   pattern = { "*.star", "*.bzl", "*.bazel" },
   callback = function()
     local result = fn.system("buildifier", current_buf_contents())
     if vim.v.shell_error == 0 then
       set_current_buf_contents(result)
     else
       vim.notify(result)
     end
   end,
})



-- Telescope
local tele = require('telescope.builtin')
kn_l_map('tf', function() tele.find_files() end)
kn_l_map('th', function() tele.help_tags() end)
kn_l_map('tg', function() tele.live_grep() end)
kn_l_map('tb', function() tele.git_branches() end)
kn_l_map('tp', function() tele.resume() end)
