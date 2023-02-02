local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- nvim-cmp
  'L3MON4D3/LuaSnip',
  'saadparwaiz1/cmp_luasnip',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-nvim-lsp-signature-help',

  -- telescope
  'nvim-telescope/telescope.nvim',
  'nvim-lua/plenary.nvim',

  -- lualine
  'nvim-lualine/lualine.nvim',
  'nvim-tree/nvim-web-devicons',

  -- others
  'ojroques/vim-oscyank',
  'neovim/nvim-lspconfig',
  'tpope/vim-commentary',
  'tpope/vim-fugitive',
  'tpope/vim-surround',
  'folke/tokyonight.nvim',
  'Rigellute/shades-of-purple.vim',
})
