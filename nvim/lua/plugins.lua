-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error('Error cloning lazy.nvim:\n' .. out)
    end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    {
        'SmiteshP/nvim-navic',
        dependencies= {'neovim/nvim-lspconfig'}
    },
    require 'plugin_config.gitsigns_config',
    require 'plugin_config.neotree_config',
    require 'plugin_config.telescope_config',
    require 'plugin_config.treesitter_config',
    require 'plugin_config.lualine_config',
    require 'plugin_config.lsp_config',
    require 'plugin_config.autocompletion_config',
    require 'plugin_config.orgmode_config',
    require 'plugin_config.colorizer_config',
    require 'plugin_config.blankline_config',
    {
        'akinsho/toggleterm.nvim',
        version = "*",
    },
    'szw/vim-maximizer',
    'tpope/vim-fugitive',
    'EdenEast/nightfox.nvim',

})
